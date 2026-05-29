package com.ontology.service;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class PriceTransmissionService {
    
    private final JdbcTemplate jdbcTemplate;
    
    public Map<String, Object> calculatePriceTransmission(String instanceId, Double latestPrice, Integer depth) {
        return calculatePriceTransmission("lithium_carbonate", instanceId, null, latestPrice, null, depth, "downstream");
    }

    public Map<String, Object> calculatePriceTransmission(
            String sourceObjectTypeId,
            String sourceInstanceId,
            Double priceChangePercent,
            Double latestPrice,
            Double previousPrice,
            Integer depth,
            String direction) {
        try {
            String normalizedDirection = (direction == null || direction.isBlank())
                    ? "downstream"
                    : direction.trim().toLowerCase();
            if (!"downstream".equals(normalizedDirection)) {
                return Map.of("success", false, "error", "当前实例层价格传导第一版仅支持 direction=downstream");
            }

            Map<String, InstanceObjectTypeMeta> objectTypeMeta = queryInstanceObjectTypeMeta();
            InstanceObjectTypeMeta sourceMeta = objectTypeMeta.get(sourceObjectTypeId);
            if (sourceMeta == null) {
                return Map.of("success", false, "error", "Object type not found: " + sourceObjectTypeId);
            }

            Set<String> transmissionWhitelist = queryPriceTransmissionWhitelist();
            Map<String, List<CoefficientEntry>> materialCoefficientMap = preloadMaterialCoefficients();
            Map<String, String> parentTypeMap = queryParentTypeMap();

            Map<String, Object> sourceInstance = queryInstanceRow(sourceMeta, sourceInstanceId);
            if (sourceInstance == null) {
                return Map.of("success", false, "error", "Instance not found: " + sourceObjectTypeId + ":" + sourceInstanceId);
            }

            double sourcePreviousPrice = isPositive(previousPrice)
                    ? previousPrice
                    : numberOrZero(sourceInstance.get("price"));

            double sourcePriceChangePercent;
            double sourceLatestPrice;
            if (priceChangePercent != null) {
                sourcePriceChangePercent = priceChangePercent;
                sourceLatestPrice = isPositive(latestPrice)
                        ? latestPrice
                        : (sourcePreviousPrice > 0 ? applyChange(sourcePreviousPrice, sourcePriceChangePercent) : 0);
            } else {
                if (latestPrice == null || latestPrice <= 0) {
                    return Map.of("success", false, "error", "priceChangePercent is required");
                }
                if (sourcePreviousPrice <= 0) {
                    return Map.of("success", false, "error", "Source instance price must be positive when priceChangePercent is not provided");
                }
                sourceLatestPrice = latestPrice;
                sourcePriceChangePercent = ((sourceLatestPrice - sourcePreviousPrice) / sourcePreviousPrice) * 100;
            }
            if (sourcePreviousPrice <= 0 && sourceLatestPrice <= 0) {
                return Map.of("success", false, "error", "Source instance price must be positive");
            }

            Map<String, Integer> depthByNode = new LinkedHashMap<>();
            Map<String, List<String>> pathByNode = new LinkedHashMap<>();
            Queue<InstanceTraversalNode> queue = new LinkedList<>();
            List<Map<String, Object>> nodes = new ArrayList<>();
            List<Map<String, Object>> edges = new ArrayList<>();
            List<Map<String, Object>> paths = new ArrayList<>();
            Set<String> visitedEdges = new HashSet<>();

            String sourceNodeId = nodeId(sourceObjectTypeId, sourceInstanceId);
            depthByNode.put(sourceNodeId, 0);
            pathByNode.put(sourceNodeId, List.of(sourceNodeId));
            queue.offer(new InstanceTraversalNode(sourceObjectTypeId, sourceInstanceId, 0));

            nodes.add(buildInstanceTransmissionNode(
                    sourceMeta,
                    sourceInstance,
                    sourceInstanceId,
                    sourcePreviousPrice,
                    sourceLatestPrice,
                    sourcePriceChangePercent,
                    0
            ));

            while (!queue.isEmpty()) {
                InstanceTraversalNode current = queue.poll();
                if (current.depth() >= depth) continue;

                List<Map<String, Object>> relations = queryPriceTransmissionInstanceRelations(
                        current.objectTypeId(),
                        current.instanceId()
                );
                for (Map<String, Object> relation : relations) {
                    String linkTypeId = (String) relation.get("linkTypeId");
                    String sourceTypeId = (String) relation.get("sourceObjectId");
                    String targetTypeId = (String) relation.get("targetObjectId");
                    String relationSourceInstanceId = (String) relation.get("sourceInstanceId");
                    String relationTargetInstanceId = (String) relation.get("targetInstanceId");

                    boolean currentIsSource = current.objectTypeId().equals(sourceTypeId)
                            && current.instanceId().equals(relationSourceInstanceId);
                    boolean currentIsTarget = current.objectTypeId().equals(targetTypeId)
                            && current.instanceId().equals(relationTargetInstanceId);
                    if (!currentIsSource && !currentIsTarget) continue;
                    // 下游传导：仅 source → target，跳过反向传导
                    if (currentIsTarget) continue;

                    String nextObjectTypeId = targetTypeId;
                    String nextInstanceId = relationTargetInstanceId;
                    InstanceObjectTypeMeta nextMeta = objectTypeMeta.get(nextObjectTypeId);
                    if (nextMeta == null) continue;
                    // 白名单过滤：不在白名单中的类型不参与价格传导
                    if (!transmissionWhitelist.contains(nextObjectTypeId)) continue;

                    int nextDepth = current.depth() + 1;
                    String currentNodeId = nodeId(current.objectTypeId(), current.instanceId());
                    String nextNodeId = nodeId(nextObjectTypeId, nextInstanceId);

                    // 查询边的传导系数（带上下文验证）
                    Optional<Double> resolvedCoeff = getEdgeCoefficient(
                            current.objectTypeId(), nextObjectTypeId, materialCoefficientMap, parentTypeMap);
                    boolean isQualitative = resolvedCoeff.isEmpty();
                    double edgeCoefficient = resolvedCoeff.orElse(0.05);
                    double depthDecay = Math.pow(0.8, Math.max(0, nextDepth - 1));
                    double rawImpactPercent = sourcePriceChangePercent * edgeCoefficient * depthDecay;
                    Double impactPercentOrNull = isQualitative ? null : rawImpactPercent;

                    Integer knownDepth = depthByNode.get(nextNodeId);
                    if (knownDepth == null) {
                        Map<String, Object> nextRow = queryInstanceRow(nextMeta, nextInstanceId);
                        if (nextRow == null) continue;

                        double nextPreviousPrice = numberOrZero(nextRow.get("price"));
                        if (nextPreviousPrice <= 0) continue;

                        double nextLatestPrice = isQualitative
                                ? nextPreviousPrice
                                : applyChange(nextPreviousPrice, rawImpactPercent);

                        depthByNode.put(nextNodeId, nextDepth);
                        pathByNode.put(nextNodeId, appendPath(pathByNode.get(currentNodeId), nextNodeId));
                        queue.offer(new InstanceTraversalNode(nextObjectTypeId, nextInstanceId, nextDepth));

                        Map<String, Object> node = buildInstanceTransmissionNode(
                                nextMeta,
                                nextRow,
                                nextInstanceId,
                                nextPreviousPrice,
                                nextLatestPrice,
                                impactPercentOrNull,
                                nextDepth);
                        if (isQualitative) {
                            node.put("coefficientType", "qualitative");
                            node.put("priceChangePercent", null);
                            node.put("changePercent", null);
                            node.put("latestPrice", null);
                            node.put("qualitativeNote", String.format(
                                    "%s价格%s可能影响%s，缺少组成项数据，仅做方向性判断",
                                    sourceMeta.name(),
                                    sourcePriceChangePercent > 0 ? "上涨" : "下跌",
                                    nextMeta.name()));
                        }
                        nodes.add(node);
                    } else if (knownDepth != nextDepth) {
                        continue;
                    }

                    String edgeKey = relation.get("id") + ":" + currentNodeId + ">" + nextNodeId;
                    if (visitedEdges.add(edgeKey)) {
                        Double impactRounded = isQualitative ? null : round(rawImpactPercent, 2);
                        List<String> pathNodeIds = appendPath(pathByNode.get(currentNodeId), nextNodeId);

                        Map<String, Object> edge = buildInstanceTransmissionEdge(
                                currentNodeId, nextNodeId, relation,
                                edgeCoefficient, depthDecay, impactRounded);
                        if (isQualitative) {
                            edge.put("coefficientType", "qualitative");
                            edge.put("impactPercent", null);
                            edge.put("coefficient", null);
                            edge.put("qualitativeNote", String.format(
                                    "%s是%s的原材料，价格%s可能传导至%s，但因缺少组成项数据，无法计算精确传导系数",
                                    sourceMeta.name(),
                                    nextMeta.name(),
                                    sourcePriceChangePercent > 0 ? "上涨" : "下跌",
                                    nextMeta.name()));
                        }
                        edges.add(edge);

                        paths.add(buildInstanceTransmissionPath(
                                pathNodeIds, relation, nextDepth,
                                edgeCoefficient, depthDecay, impactRounded));
                    }
                }
            }

            List<Map<String, Object>> affectedInstances = new ArrayList<>();
            double totalPriceChangeAmount = 0;
            for (Map<String, Object> node : nodes) {
                String nodeId = (String) node.get("id");
                if (nodeId.equals(sourceNodeId)) continue;

                double nodePreviousPrice = numberOrZero(node.get("previousPrice"));
                double nodeLatestPrice = numberOrZero(node.get("latestPrice"));
                double priceChangeAmount = nodeLatestPrice - nodePreviousPrice;
                Map<String, Object> affectedInstance = new LinkedHashMap<>();
                affectedInstance.put("id", node.get("instanceId"));
                affectedInstance.put("objectTypeId", node.get("objectTypeId"));
                affectedInstance.put("objectTypeName", node.get("objectTypeName"));
                affectedInstance.put("name", node.get("name"));
                affectedInstance.put("relationPath", String.join(" → ", pathByNode.getOrDefault(nodeId, List.of(nodeId))));
                affectedInstance.put("relationDepth", node.get("depth"));
                affectedInstance.put("previousPrice", node.get("previousPrice"));
                affectedInstance.put("transmissionCoefficient", node.get("priceChangePercent"));
                affectedInstance.put("latestPrice", node.get("latestPrice"));
                affectedInstance.put("priceChangeAmount", round(priceChangeAmount, 2));

                affectedInstances.add(affectedInstance);
                totalPriceChangeAmount += priceChangeAmount;
            }

            Map<String, Object> sourceResult = new LinkedHashMap<>();
            sourceResult.put("id", sourceInstanceId);
            sourceResult.put("objectTypeId", sourceObjectTypeId);
            sourceResult.put("objectTypeName", sourceMeta.name());
            sourceResult.put("instanceId", sourceInstanceId);
            sourceResult.put("name", resolveInstanceName(sourceInstance, sourceInstanceId));
            sourceResult.put("previousPrice", round(sourcePreviousPrice, 2));
            sourceResult.put("latestPrice", round(sourceLatestPrice, 2));
            sourceResult.put("priceChangePercent", round(sourcePriceChangePercent, 2));

            Map<String, Object> summary = new LinkedHashMap<>();
            summary.put("instanceCount", nodes.size());
            summary.put("edgeCount", edges.size());
            summary.put("pathCount", paths.size());
            summary.put("depth", depth);
            summary.put("sourceObjectTypeId", sourceObjectTypeId);
            summary.put("sourceInstanceId", sourceInstanceId);
            summary.put("direction", normalizedDirection);
            summary.put("edgeCoefficient", 0.5);
            summary.put("depthDecay", 0.8);
            summary.put("totalAffectedInstances", affectedInstances.size());
            summary.put("totalPriceChangeAmount", round(totalPriceChangeAmount, 2));

            Map<String, Object> data = new LinkedHashMap<>();
            data.put("sourceInstance", sourceResult);
            data.put("nodes", nodes);
            data.put("edges", edges);
            data.put("paths", paths);
            data.put("transmissionCoefficient", round(sourcePriceChangePercent, 2));
            data.put("affectedInstances", affectedInstances);
            data.put("summary", summary);

            return Map.of("success", true, "data", data);

        } catch (Exception e) {
            return Map.of("success", false, "error", e.getMessage());
        }
    }

    public Map<String, Object> calculateObjectTypePriceTransmission(
            String objectTypeId,
            Double priceChangePercent,
            Integer depth,
            String direction,
            Double previousPrice,
            Double latestPrice) {
        String normalizedDirection = (direction == null || direction.isBlank())
                ? "downstream"
                : direction.trim().toLowerCase();
        if (!"downstream".equals(normalizedDirection)) {
            return Map.of("success", false, "error", "当前概念层价格传导第一版仅支持 direction=downstream");
        }

        Map<String, Map<String, Object>> objectTypeMeta = queryObjectTypeMeta();
        Map<String, Object> sourceMeta = objectTypeMeta.get(objectTypeId);
        if (sourceMeta == null) {
            return Map.of("success", false, "error", "Object type not found: " + objectTypeId);
        }

        // 获取价格传导白名单（仅白名单内的对象类型参与传导）
        Set<String> transmissionWhitelist = queryPriceTransmissionWhitelist();
        // 预加载组成项传导系数表（含上下文验证）
        Map<String, List<CoefficientEntry>> materialCoefficientMap = preloadMaterialCoefficients();
        // 对象类型父类型映射（用于系数上下文验证）
        Map<String, String> parentTypeMap = queryParentTypeMap();

        Map<String, Integer> depthByObjectType = new LinkedHashMap<>();
        Queue<String> queue = new LinkedList<>();
        List<Map<String, Object>> edges = new ArrayList<>();
        List<Map<String, Object>> paths = new ArrayList<>();
        Set<String> visitedEdges = new HashSet<>();
        Map<String, List<String>> pathByObjectType = new LinkedHashMap<>();
        List<Map<String, Object>> dataUnavailableNotes = new ArrayList<>();
        Set<String> dataUnavailableTypes = new HashSet<>();
        // 记录每个节点首次被访问时的入边传导系数
        Map<String, Double> incomingCoefficientMap = new HashMap<>();
        // 记录通过定性传导（无精确系数）到达的节点
        Set<String> qualitativeNodes = new HashSet<>();

        depthByObjectType.put(objectTypeId, 0);
        pathByObjectType.put(objectTypeId, List.of(objectTypeId));
        queue.offer(objectTypeId);

        while (!queue.isEmpty()) {
            String currentObjectTypeId = queue.poll();
            int currentDepth = depthByObjectType.get(currentObjectTypeId);
            if (currentDepth >= depth) continue;

            List<Map<String, Object>> linkTypes = queryPriceTransmissionLinkTypes(currentObjectTypeId);
            for (Map<String, Object> linkType : linkTypes) {
                String sourceId = (String) linkType.get("sourceObjectId");
                String targetId = (String) linkType.get("targetObjectId");
                // 下游传导：仅沿 source → target 方向遍历，跳过反向链接
                if (currentObjectTypeId.equals(targetId)) continue;
                String nextObjectTypeId = targetId;
                if (nextObjectTypeId == null || nextObjectTypeId.equals(currentObjectTypeId)) continue;
                if (!objectTypeMeta.containsKey(nextObjectTypeId)) continue;

                // 白名单过滤：不在白名单中的类型不参与价格传导
                if (!transmissionWhitelist.contains(nextObjectTypeId)) continue;

                // 处理数据不可得类型（如 new_energy_vehicle）：创建占位节点，不继续遍历
                if (isDataUnavailableObjectType(nextObjectTypeId)) {
                    int nextDepth = currentDepth + 1;
                    if (!depthByObjectType.containsKey(nextObjectTypeId)) {
                        depthByObjectType.put(nextObjectTypeId, nextDepth);
                        pathByObjectType.put(nextObjectTypeId, appendPath(pathByObjectType.get(currentObjectTypeId), nextObjectTypeId));
                        dataUnavailableTypes.add(nextObjectTypeId);
                    }
                    String edgeKey = linkType.get("id") + ":" + currentObjectTypeId + ">" + nextObjectTypeId;
                    if (visitedEdges.add(edgeKey)) {
                        Optional<Double> resolvedPlaceholderCoeff = getEdgeCoefficient(
                                currentObjectTypeId, nextObjectTypeId, materialCoefficientMap, parentTypeMap);
                        double edgeCoefficient = resolvedPlaceholderCoeff.orElse(0.05);
                        double depthDecay = Math.pow(0.8, Math.max(0, nextDepth - 1));
                        double impactPercent = priceChangePercent * edgeCoefficient * depthDecay;
                        edges.add(buildObjectTypeEdge(currentObjectTypeId, nextObjectTypeId,
                                (String) linkType.get("id"), (String) linkType.get("name"),
                                edgeCoefficient, depthDecay, round(impactPercent, 2), priceChangePercent));
                        List<String> pathObjectTypeIds = appendPath(pathByObjectType.get(currentObjectTypeId), nextObjectTypeId);
                        paths.add(buildObjectTypePath(pathObjectTypeIds, linkType, nextDepth,
                                edgeCoefficient, depthDecay, round(impactPercent, 2)));
                        Map<String, Object> meta = objectTypeMeta.get(nextObjectTypeId);
                        dataUnavailableNotes.add(Map.of(
                                "objectTypeId", nextObjectTypeId,
                                "objectTypeName", meta != null ? meta.get("name") : nextObjectTypeId,
                                "dataType", "placeholder",
                                "hint", "需获取工信部公告（《道路机动车辆生产企业及产品》）中的单车带电量（kWh/辆）数据"
                        ));
                    }
                    continue;
                }

                int nextDepth = currentDepth + 1;
                // 按上下文查询传导系数：仅当目标类型属于该系数的有效体系时才使用精确值，否则定性处理
                Optional<Double> resolvedCoeff = getEdgeCoefficient(
                        currentObjectTypeId, nextObjectTypeId, materialCoefficientMap, parentTypeMap);
                boolean isQualitative = resolvedCoeff.isEmpty();
                double edgeCoefficient = resolvedCoeff.orElse(0.05);
                Integer knownDepth = depthByObjectType.get(nextObjectTypeId);
                if (knownDepth == null) {
                    incomingCoefficientMap.put(nextObjectTypeId, edgeCoefficient);
                    depthByObjectType.put(nextObjectTypeId, nextDepth);
                    pathByObjectType.put(nextObjectTypeId, appendPath(pathByObjectType.get(currentObjectTypeId), nextObjectTypeId));
                    if (isQualitative) qualitativeNodes.add(nextObjectTypeId);
                    queue.offer(nextObjectTypeId);
                } else if (knownDepth != nextDepth) {
                    continue;
                }

                String edgeKey = linkType.get("id") + ":" + currentObjectTypeId + ">" + nextObjectTypeId;
                if (visitedEdges.add(edgeKey)) {
                    double depthDecay = Math.pow(0.8, Math.max(0, nextDepth - 1));
                    double impactPercent = priceChangePercent * edgeCoefficient * depthDecay;
                    List<String> pathObjectTypeIds = appendPath(pathByObjectType.get(currentObjectTypeId), nextObjectTypeId);
                    Map<String, Object> edge = buildObjectTypeEdge(
                            currentObjectTypeId,
                            nextObjectTypeId,
                            (String) linkType.get("id"),
                            (String) linkType.get("name"),
                            edgeCoefficient,
                            depthDecay,
                            isQualitative ? null : round(impactPercent, 2),
                            priceChangePercent);
                    if (isQualitative) {
                        edge.put("coefficientType", "qualitative");
                        edge.put("impactPercent", null);
                        edge.put("coefficient", null);
                        edge.put("qualitativeNote", String.format(
                                "%s是%s的原材料，价格%s可能传导至%s，但因缺少组成项数据，无法计算精确传导系数",
                                objectTypeMeta.get(currentObjectTypeId).get("name"),
                                objectTypeMeta.get(nextObjectTypeId).get("name"),
                                priceChangePercent > 0 ? "上涨" : "下跌",
                                objectTypeMeta.get(nextObjectTypeId).get("name")));
                    }
                    edges.add(edge);
                    Map<String, Object> path = buildObjectTypePath(
                            pathObjectTypeIds,
                            linkType,
                            nextDepth,
                            edgeCoefficient,
                            depthDecay,
                            isQualitative ? null : round(impactPercent, 2));
                    if (isQualitative) {
                        path.put("coefficientType", "qualitative");
                        path.put("impactPercent", null);
                    }
                    paths.add(path);
                }
            }
        }

        List<Map<String, Object>> nodes = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : depthByObjectType.entrySet()) {
            String nodeObjectTypeId = entry.getKey();
            int nodeDepth = entry.getValue();
            Map<String, Object> meta = objectTypeMeta.get(nodeObjectTypeId);
            String objectTypeName = (String) meta.get("name");

            // 占位节点（数据不可得，如 new_energy_vehicle）
            if (dataUnavailableTypes.contains(nodeObjectTypeId)) {
                Map<String, Object> placeholderNode = new LinkedHashMap<>();
                placeholderNode.put("id", nodeObjectTypeId);
                placeholderNode.put("name", objectTypeName);
                placeholderNode.put("subtitle", "需补充数据");
                placeholderNode.put("depth", nodeDepth);
                placeholderNode.put("placeholder", true);
                placeholderNode.put("dataUnavailable", true);
                nodes.add(placeholderNode);
                continue;
            }

            String tableName = (String) meta.get("backingDataset");
            double baselinePrice = nodeObjectTypeId.equals(objectTypeId) && isPositive(previousPrice)
                    ? previousPrice
                    : medianPriceOrDefault(tableName, defaultPriceForObjectType(nodeObjectTypeId));
            double nodeCoefficient = nodeDepth == 0 ? 0 : incomingCoefficientMap.getOrDefault(nodeObjectTypeId, 0.3);
            boolean nodeIsQualitative = nodeDepth > 0 && qualitativeNodes.contains(nodeObjectTypeId);

            Map<String, Object> node;
            if (nodeIsQualitative) {
                // 定性节点：不展示数值，仅保留基线价格
                double qualBaselinePrice = nodeObjectTypeId.equals(objectTypeId) && isPositive(previousPrice)
                        ? previousPrice : baselinePrice;
                node = buildObjectTypeNode(
                        nodeObjectTypeId, objectTypeName,
                        "L" + (nodeDepth + 1) + " / " + objectTypeName,
                        qualBaselinePrice, qualBaselinePrice, null, nodeDepth);
                node.put("coefficientType", "qualitative");
                node.put("priceChangePercent", null);
                node.put("changePercent", null);
                node.put("latestPrice", node.get("previousPrice"));
                node.put("qualitativeNote", String.format(
                        "%s价格%s可能影响%s，缺少组成项数据，仅做方向性判断",
                        objectTypeMeta.get(objectTypeId).get("name"),
                        priceChangePercent > 0 ? "上涨" : "下跌",
                        objectTypeName));
            } else {
                double nodeImpactPercent = nodeDepth == 0
                        ? priceChangePercent
                        : priceChangePercent * nodeCoefficient * Math.pow(0.8, Math.max(0, nodeDepth - 1));
                double nodeLatestPrice = nodeObjectTypeId.equals(objectTypeId) && isPositive(latestPrice)
                        ? latestPrice
                        : applyChange(baselinePrice, nodeImpactPercent);
                node = buildObjectTypeNode(
                        nodeObjectTypeId, objectTypeName,
                        "L" + (nodeDepth + 1) + " / " + objectTypeName,
                        baselinePrice, nodeLatestPrice, nodeImpactPercent, nodeDepth);
            }
            nodes.add(node);
        }

        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("objectTypeCount", nodes.size());
        summary.put("edgeCount", edges.size());
        summary.put("pathCount", paths.size());
        summary.put("depth", depth);
        summary.put("sourceObjectTypeId", objectTypeId);
        summary.put("direction", normalizedDirection);
        summary.put("edgeCoefficient", 0.5);
        summary.put("depthDecay", 0.8);

        Map<String, Object> source = new LinkedHashMap<>();
        source.put("objectTypeId", objectTypeId);
        source.put("objectTypeName", sourceMeta.get("name"));
        double sourcePreviousPrice = nodes.isEmpty() ? 0 : ((Number) nodes.get(0).get("previousPrice")).doubleValue();
        double sourceLatestPrice = nodes.isEmpty() ? 0 : ((Number) nodes.get(0).get("latestPrice")).doubleValue();
        source.put("previousPrice", round(sourcePreviousPrice, 2));
        source.put("latestPrice", round(sourceLatestPrice, 2));
        source.put("priceChangePercent", round(priceChangePercent, 2));

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("sourceObjectType", source);
        data.put("nodes", nodes);
        data.put("edges", edges);
        data.put("paths", paths);
        data.put("summary", summary);
        data.put("dataUnavailableNotes", dataUnavailableNotes);

        return Map.of("success", true, "data", data);
    }

    private Map<String, Object> querySourceInstance(String instanceId) {
        String sql = "SELECT * FROM lithium_carbonate WHERE unique_id = ?";
        List<Map<String, Object>> results = jdbcTemplate.queryForList(sql, instanceId);
        if (results.isEmpty()) return null;
        return results.get(0);
    }
    
    private Double queryInstancePrice(String objectTypeId, String instanceId) {
        try {
            String sql = "SELECT price FROM " + objectTypeId + " WHERE unique_id = ?";
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql, instanceId);
            if (results.isEmpty()) return null;
            Object priceObj = results.get(0).get("price");
            if (priceObj == null) return null;
            return ((Number) priceObj).doubleValue();
        } catch (Exception e) {
            return null;
        }
    }

    private Map<String, InstanceObjectTypeMeta> queryInstanceObjectTypeMeta() {
        String sql = """
                SELECT ot.id,
                       ot.name,
                       ot.backing_dataset AS backingDataset,
                       COALESCE(pk.base_column, 'unique_id') AS primaryKeyColumn
                FROM object_types ot
                LEFT JOIN properties pk
                  ON pk.object_type_id = ot.id
                 AND pk.is_primary_key = 1
                """;
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
        Map<String, InstanceObjectTypeMeta> result = new LinkedHashMap<>();
        for (Map<String, Object> row : rows) {
            String id = (String) row.get("id");
            result.put(id, new InstanceObjectTypeMeta(
                    id,
                    (String) row.get("name"),
                    (String) row.get("backingDataset"),
                    (String) row.get("primaryKeyColumn")
            ));
        }
        return result;
    }

    private Map<String, Object> queryInstanceRow(InstanceObjectTypeMeta meta, String instanceId) {
        if (meta == null || meta.backingDataset() == null || meta.backingDataset().isBlank()) {
            return null;
        }
        String sql = String.format(
                "SELECT * FROM `%s` WHERE `%s` = ? LIMIT 1",
                safeIdentifier(meta.backingDataset()),
                safeIdentifier(meta.primaryKeyColumn())
        );
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, instanceId);
        return rows.isEmpty() ? null : rows.get(0);
    }

    private List<Map<String, Object>> queryPriceTransmissionInstanceRelations(String objectTypeId, String instanceId) {
        String sql = """
                SELECT lid.id,
                       lid.link_type_id AS linkTypeId,
                       lid.source_instance_id AS sourceInstanceId,
                       lid.target_instance_id AS targetInstanceId,
                       lt.name AS linkTypeName,
                       lt.source_object_id AS sourceObjectId,
                       lt.target_object_id AS targetObjectId
                FROM link_instance_data lid
                JOIN link_types lt ON lt.id COLLATE utf8mb4_unicode_ci = lid.link_type_id
                WHERE (lid.source_instance_id = ? OR lid.target_instance_id = ?)
                  AND LOWER(COALESCE(lt.status, 'active')) IN ('active', 'pending')
                  AND lt.source_object_id NOT IN ('company_entity', 'event_entity')
                  AND lt.target_object_id NOT IN ('company_entity', 'event_entity')
                  AND (
                    (lt.source_object_id = ? AND lid.source_instance_id = ?)
                    OR
                    (lt.target_object_id = ? AND lid.target_instance_id = ?)
                  )
                ORDER BY lid.id
                """;
        return jdbcTemplate.queryForList(sql, instanceId, instanceId, objectTypeId, instanceId, objectTypeId, instanceId);
    }

    private Map<String, Object> buildInstanceTransmissionNode(
            InstanceObjectTypeMeta meta,
            Map<String, Object> row,
            String instanceId,
            double previousPrice,
            double latestPrice,
            Double changePercent,
            int depth) {
        Map<String, Object> node = new LinkedHashMap<>();
        node.put("id", nodeId(meta.id(), instanceId));
        node.put("objectTypeId", meta.id());
        node.put("objectTypeName", meta.name());
        node.put("instanceId", instanceId);
        node.put("name", resolveInstanceName(row, instanceId));
        node.put("label", resolveInstanceName(row, instanceId));
        node.put("previousPrice", round(previousPrice, 2));
        node.put("latestPrice", round(latestPrice, 2));
        node.put("priceChangePercent", changePercent != null ? round(changePercent, 2) : null);
        node.put("changePercent", changePercent != null ? round(changePercent, 2) : null);
        node.put("depth", depth);
        node.put("data", row);
        return node;
    }

    private Map<String, Object> buildInstanceTransmissionEdge(
            String source,
            String target,
            Map<String, Object> relation,
            double edgeCoefficient,
            double depthDecay,
            Double impactPercent) {
        Map<String, Object> edge = new LinkedHashMap<>();
        edge.put("source", source);
        edge.put("target", target);
        edge.put("linkInstanceId", String.valueOf(relation.get("id")));
        edge.put("linkTypeId", relation.get("linkTypeId"));
        edge.put("linkTypeName", relation.get("linkTypeName"));
        edge.put("transmissionCoefficient", round(edgeCoefficient, 2));
        edge.put("edgeCoefficient", round(edgeCoefficient, 2));
        edge.put("depthDecay", round(depthDecay, 2));
        edge.put("impactPercent", impactPercent);
        edge.put("coefficient", impactPercent);
        edge.put("label", impactPercent != null
                ? "影响 " + (impactPercent >= 0 ? "+" : "") + round(impactPercent, 2) + "%"
                : "方向性传导");
        return edge;
    }

    private Map<String, Object> buildInstanceTransmissionPath(
            List<String> instanceNodeIds,
            Map<String, Object> terminalRelation,
            int depth,
            double edgeCoefficient,
            double depthDecay,
            Double impactPercent) {
        Map<String, Object> path = new LinkedHashMap<>();
        path.put("instanceIds", instanceNodeIds);
        path.put("terminalLinkInstanceId", String.valueOf(terminalRelation.get("id")));
        path.put("terminalLinkTypeId", terminalRelation.get("linkTypeId"));
        path.put("terminalLinkTypeName", terminalRelation.get("linkTypeName"));
        path.put("depth", depth);
        path.put("transmissionCoefficient", round(edgeCoefficient, 2));
        path.put("depthDecay", round(depthDecay, 2));
        path.put("impactPercent", impactPercent);
        return path;
    }

    private String nodeId(String objectTypeId, String instanceId) {
        return objectTypeId + ":" + instanceId;
    }

    private String resolveInstanceName(Map<String, Object> row, String fallback) {
        if (row == null) return fallback;
        for (String key : List.of("name", "material_name", "model_name", "model", "grade", "manufacturer")) {
            Object value = row.get(key);
            if (value != null && !String.valueOf(value).isBlank()) {
                return String.valueOf(value);
            }
        }
        return fallback;
    }

    private double numberOrZero(Object value) {
        if (value instanceof Number number) {
            return number.doubleValue();
        }
        if (value instanceof String stringValue) {
            try {
                return Double.parseDouble(stringValue);
            } catch (NumberFormatException ignored) {
                return 0;
            }
        }
        return 0;
    }

    private String safeIdentifier(String value) {
        if (value == null || !value.matches("[A-Za-z0-9_]+")) {
            throw new IllegalArgumentException("Unsafe SQL identifier: " + value);
        }
        return value;
    }

    private record InstanceObjectTypeMeta(String id, String name, String backingDataset, String primaryKeyColumn) {}

    private record InstanceTraversalNode(String objectTypeId, String instanceId, int depth) {}
    
    private Map<String, Object> queryRelationGraph(String objectTypeId, String instanceId, int depth) {
        // 使用递归查询获取关系图谱
        Set<String> visitedNodes = new HashSet<>();
        Set<String> visitedLinks = new HashSet<>();
        List<Map<String, Object>> nodes = new ArrayList<>();
        List<Map<String, Object>> links = new ArrayList<>();
        
        // 添加源节点
        Map<String, Object> sourceNode = buildNode(objectTypeId, instanceId, 0);
        if (sourceNode != null) {
            nodes.add(sourceNode);
            visitedNodes.add(objectTypeId + ":" + instanceId);
        }
        
        // BFS递归查询
        Queue<Map<String, Object>> queue = new LinkedList<>();
        queue.offer(Map.of("objectTypeId", objectTypeId, "instanceId", instanceId, "depth", 0));
        
        while (!queue.isEmpty()) {
            Map<String, Object> current = queue.poll();
            String currentObjectType = (String) current.get("objectTypeId");
            String currentInstanceId = (String) current.get("instanceId");
            int currentDepth = (Integer) current.get("depth");
            
            if (currentDepth >= depth) continue;
            
            // 查询下游关系
            queryAndAddRelations(currentObjectType, currentInstanceId, currentDepth, 
                "source_object_type", "source_object_id", "downstream",
                visitedNodes, visitedLinks, nodes, links, queue);
            
            // 查询上游关系
            queryAndAddRelations(currentObjectType, currentInstanceId, currentDepth,
                "target_object_type", "target_object_id", "upstream",
                visitedNodes, visitedLinks, nodes, links, queue);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("nodes", nodes);
        result.put("links", links);
        return result;
    }
    
    private void queryAndAddRelations(String objectTypeId, String instanceId, int currentDepth,
                                      String queryField, String queryIdField, String direction,
                                      Set<String> visitedNodes, Set<String> visitedLinks,
                                      List<Map<String, Object>> nodes, List<Map<String, Object>> links,
                                      Queue<Map<String, Object>> queue) {
        // link_instance_data 表结构：id, link_type_id, source_instance_id, target_instance_id
        String sql;
        List<Map<String, Object>> relations;
        
        if ("downstream".equals(direction)) {
            // 查询下游：当前实例作为source
            sql = "SELECT * FROM link_instance_data WHERE source_instance_id = ?";
            relations = jdbcTemplate.queryForList(sql, instanceId);
        } else {
            // 查询上游：当前实例作为target
            sql = "SELECT * FROM link_instance_data WHERE target_instance_id = ?";
            relations = jdbcTemplate.queryForList(sql, instanceId);
        }
        
        for (Map<String, Object> relation : relations) {
            String linkTypeId = (String) relation.get("link_type_id");
            String linkTypeName = queryLinkTypeName(linkTypeId);
            
            String targetInstanceId;
            if ("downstream".equals(direction)) {
                targetInstanceId = (String) relation.get("target_instance_id");
            } else {
                targetInstanceId = (String) relation.get("source_instance_id");
            }
            
            // 从实例ID解析对象类型
            String targetObjectType = inferObjectTypeFromInstanceId(targetInstanceId);
            if (targetObjectType == null) continue;
            
            String targetNodeId = targetObjectType + ":" + targetInstanceId;
            Long linkId = ((Number) relation.get("id")).longValue();
            String linkIdStr = String.valueOf(linkId);
            
            // 添加目标节点
            if (!visitedNodes.contains(targetNodeId)) {
                Map<String, Object> targetNode = buildNode(targetObjectType, targetInstanceId, currentDepth + 1);
                if (targetNode != null) {
                    nodes.add(targetNode);
                    visitedNodes.add(targetNodeId);
                    queue.offer(Map.of("objectTypeId", targetObjectType, "instanceId", targetInstanceId, "depth", currentDepth + 1));
                }
            }
            
            // 添加链接
            if (!visitedLinks.contains(linkIdStr)) {
                Map<String, Object> link = new LinkedHashMap<>();
                link.put("id", linkIdStr);
                link.put("source", "downstream".equals(direction) ? (objectTypeId + ":" + instanceId) : targetNodeId);
                link.put("target", "downstream".equals(direction) ? targetNodeId : (objectTypeId + ":" + instanceId));
                link.put("linkTypeId", linkTypeId);
                link.put("linkTypeName", linkTypeName);
                link.put("direction", direction);
                links.add(link);
                visitedLinks.add(linkIdStr);
            }
        }
    }
    
    private String inferObjectTypeFromInstanceId(String instanceId) {
        // 根据实例ID前缀推断对象类型
        if (instanceId.startsWith("LC-")) return "lithium_carbonate";
        if (instanceId.startsWith("CM-")) return "cathode_material";
        if (instanceId.startsWith("BC-")) return "battery_cell";
        if (instanceId.startsWith("BM-")) return "battery_module";
        if (instanceId.startsWith("BP-")) return "battery_pack";
        if (instanceId.startsWith("NEV-")) return "new_energy_vehicle";
        if (instanceId.startsWith("EL-")) return "battery_electrolyte";
        if (instanceId.startsWith("AN-")) return "battery_anode";
        if (instanceId.startsWith("SEP-")) return "battery_separator";
        // 默认返回null，表示无法识别
        return null;
    }
    
    private Map<String, Object> buildNode(String objectTypeId, String instanceId, int depth) {
        try {
            // 查询对象类型名称
            String objectTypeSql = "SELECT name FROM object_types WHERE id = ?";
            List<Map<String, Object>> objectTypeResults = jdbcTemplate.queryForList(objectTypeSql, objectTypeId);
            String objectTypeName = objectTypeResults.isEmpty() ? objectTypeId : (String) objectTypeResults.get(0).get("name");
            
            // 查询实例数据
            String instanceSql = "SELECT * FROM " + objectTypeId + " WHERE unique_id = ?";
            List<Map<String, Object>> instanceResults = jdbcTemplate.queryForList(instanceSql, instanceId);
            if (instanceResults.isEmpty()) return null;
            
            Map<String, Object> instanceData = instanceResults.get(0);
            String name = instanceData.get("grade") != null ? (String) instanceData.get("grade") : instanceId;
            
            Map<String, Object> node = new LinkedHashMap<>();
            node.put("id", objectTypeId + ":" + instanceId);
            node.put("objectTypeId", objectTypeId);
            node.put("objectTypeName", objectTypeName);
            node.put("instanceId", instanceId);
            node.put("label", instanceId);
            node.put("data", instanceData);
            node.put("depth", depth);
            
            return node;
        } catch (Exception e) {
            return null;
        }
    }
    
    private String queryLinkTypeName(String linkTypeId) {
        try {
            String sql = "SELECT name FROM link_types WHERE id = ?";
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql, linkTypeId);
            return results.isEmpty() ? linkTypeId : (String) results.get(0).get("name");
        } catch (Exception e) {
            return linkTypeId;
        }
    }
    
    private String buildRelationPath(String sourceNodeId, String targetNodeId, 
                                     List<Map<String, Object>> links, 
                                     Map<String, Integer> nodeDepthMap) {
        // 简化的路径构建，实际应该使用BFS找到最短路径
        StringBuilder path = new StringBuilder();
        String[] sourceParts = sourceNodeId.split(":");
        String[] targetParts = targetNodeId.split(":");
        
        path.append(sourceParts[1]).append(" → ");
        
        Integer targetDepth = nodeDepthMap.get(targetNodeId);
        if (targetDepth != null && targetDepth > 1) {
            path.append("... → ");
        }
        
        path.append(targetParts[1]);
        return path.toString();
    }
    
    private double round(double value, int places) {
        double factor = Math.pow(10, places);
        return Math.round(value * factor) / factor;
    }

    private double applyChange(double basePrice, double percent) {
        return round(basePrice * (1 + percent / 100), 2);
    }

    private boolean isPositive(Double value) {
        return value != null && value > 0;
    }

    private double medianPriceOrDefault(String tableName, double defaultValue) {
        try {
            if (tableName == null || tableName.isBlank()) {
                return defaultValue;
            }
            String sql = String.format(
                    "SELECT price FROM %s WHERE price IS NOT NULL AND price > 0 ORDER BY price ASC",
                    tableName
            );
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
            if (rows.isEmpty()) {
                return defaultValue;
            }

            int size = rows.size();
            if (size % 2 == 1) {
                Object middle = rows.get(size / 2).get("price");
                return middle == null ? defaultValue : ((Number) middle).doubleValue();
            }

            Object left = rows.get(size / 2 - 1).get("price");
            Object right = rows.get(size / 2).get("price");
            if (left == null || right == null) {
                return defaultValue;
            }
            return (((Number) left).doubleValue() + ((Number) right).doubleValue()) / 2.0;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private Map<String, Object> buildObjectTypeNode(
            String id,
            String name,
            String subtitle,
            double previousPrice,
            double latestPrice,
            Double changePercent,
            int depth) {
        Map<String, Object> node = new LinkedHashMap<>();
        node.put("id", id);
        node.put("name", name);
        node.put("subtitle", subtitle);
        node.put("previousPrice", round(previousPrice, 2));
        node.put("latestPrice", round(latestPrice, 2));
        node.put("priceChangePercent", changePercent != null ? round(changePercent, 2) : null);
        node.put("changePercent", changePercent != null ? round(changePercent, 2) : null);
        node.put("level", subtitle);
        node.put("depth", depth);
        return node;
    }

    private Map<String, Object> buildObjectTypeEdge(String source, String target, double coefficient) {
        Map<String, Object> edge = new LinkedHashMap<>();
        edge.put("source", source);
        edge.put("target", target);
        edge.put("coefficient", coefficient);
        edge.put("label", "传导系数 " + (coefficient >= 0 ? "+" : "") + round(coefficient, 2) + "%");
        return edge;
    }

    private Map<String, Object> buildObjectTypeEdge(
            String source,
            String target,
            String linkTypeId,
            String linkTypeName,
            double edgeCoefficient,
            double depthDecay,
            Double impactPercent,
            double priceChangePercent) {
        Map<String, Object> edge = new LinkedHashMap<>();
        edge.put("source", source);
        edge.put("target", target);
        edge.put("linkTypeId", linkTypeId);
        edge.put("linkTypeName", linkTypeName);
        edge.put("transmissionCoefficient", round(edgeCoefficient, 2));
        edge.put("edgeCoefficient", round(edgeCoefficient, 2));
        edge.put("depthDecay", round(depthDecay, 2));
        edge.put("impactPercent", impactPercent);
        edge.put("coefficient", impactPercent);
        edge.put("label", impactPercent != null
                ? "影响 " + (impactPercent >= 0 ? "+" : "") + round(impactPercent, 2) + "%"
                : "影响" + (priceChangePercent >= 0 ? "+" : "-"));
        return edge;
    }

    private Map<String, Object> buildObjectTypePath(
            List<String> objectTypeIds,
            Map<String, Object> terminalLinkType,
            int depth,
            double edgeCoefficient,
            double depthDecay,
            Double impactPercent) {
        Map<String, Object> path = new LinkedHashMap<>();
        path.put("objectTypeIds", objectTypeIds);
        path.put("terminalLinkTypeId", terminalLinkType.get("id"));
        path.put("terminalLinkTypeName", terminalLinkType.get("name"));
        path.put("depth", depth);
        path.put("transmissionCoefficient", round(edgeCoefficient, 2));
        path.put("depthDecay", round(depthDecay, 2));
        path.put("impactPercent", impactPercent);
        return path;
    }

    private List<String> appendPath(List<String> path, String nextObjectTypeId) {
        List<String> nextPath = new ArrayList<>();
        if (path != null) {
            nextPath.addAll(path);
        }
        nextPath.add(nextObjectTypeId);
        return nextPath;
    }

    private Map<String, Map<String, Object>> queryObjectTypeMeta() {
        String sql = """
                SELECT id, name, backing_dataset AS backingDataset
                FROM object_types
                """;
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
        Map<String, Map<String, Object>> result = new LinkedHashMap<>();
        for (Map<String, Object> row : rows) {
            result.put((String) row.get("id"), row);
        }
        return result;
    }

    private List<Map<String, Object>> queryPriceTransmissionLinkTypes(String objectTypeId) {
        String sql = """
                SELECT id,
                       name,
                       source_object_id AS sourceObjectId,
                       target_object_id AS targetObjectId
                FROM link_types
                WHERE (source_object_id = ? OR target_object_id = ?)
                  AND LOWER(COALESCE(status, 'active')) IN ('active', 'pending')
                  AND source_object_id NOT IN ('company_entity', 'event_entity')
                  AND target_object_id NOT IN ('company_entity', 'event_entity')
                ORDER BY id
                """;
        return jdbcTemplate.queryForList(sql, objectTypeId, objectTypeId);
    }

    private double defaultPriceForObjectType(String objectTypeId) {
        return switch (objectTypeId) {
            case "lithium_carbonate" -> 12.55;
            case "cathode_material" -> 8.40;
            case "battery_electrolyte" -> 6.50;
            case "battery_cell" -> 1.12;
            case "power_battery" -> 4.80;
            case "new_energy_vehicle" -> 18.60;
            default -> 1.00;
        };
    }

    /**
     * 查询价格传导白名单：仅原材料、电池原材料、正极材料、零部件父类下的 OT 参与传导，
     * 以及新能源整车（占位提示）。
     */
    private Set<String> queryPriceTransmissionWhitelist() {
        String sql = """
                SELECT id FROM object_types
                WHERE parent_object_type IN ('raw_materials', 'battery_raw_materials', 'cathode_material', 'components')
                   OR id IN ('new_energy_vehicle')
                """;
        return new HashSet<>(jdbcTemplate.queryForList(sql, String.class));
    }

    /**
     * 组成项传导系数条目：携带系数的有效上下文（该系数仅在传导至指定父类或其子类时有效）。
     */
    private record CoefficientEntry(double coefficient, String validTargetParentId) {}

    /**
     * 从所有 *_composition_item 表中预加载组成项传导系数。
     * 每笔系数附带其有效目标父类型（如 cathode_material_composition_item 中的系数仅当目标为正极材料体系时有效）。
     * 子类如果无独立系数则继承父类系数及上下文。
     */
    private Map<String, List<CoefficientEntry>> preloadMaterialCoefficients() {
        Map<String, List<CoefficientEntry>> coefficientMap = new HashMap<>();

        // 1. 收集所有 *_composition_item 表
        List<Map<String, Object>> tables = jdbcTemplate.queryForList(
                "SELECT TABLE_NAME FROM information_schema.tables " +
                "WHERE TABLE_SCHEMA = (SELECT DATABASE()) AND TABLE_NAME LIKE '%_composition_item'"
        );

        // 2. 从每张表中读取 (composition_item_object_type_id, cost_ratio)，从表名提取有效目标父类型
        for (Map<String, Object> table : tables) {
            String tableName = (String) table.get("TABLE_NAME");
            // 表名如 cathode_material_composition_item → 有效目标父类型为 cathode_material
            String validTargetParentId = tableName.replace("_composition_item", "");
            try {
                String sql = String.format(
                        "SELECT composition_item_object_type_id, cost_ratio FROM %s WHERE cost_ratio IS NOT NULL AND cost_ratio > 0",
                        safeIdentifier(tableName)
                );
                List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
                for (Map<String, Object> row : rows) {
                    String objectTypeId = (String) row.get("composition_item_object_type_id");
                    Number costRatio = (Number) row.get("cost_ratio");
                    if (objectTypeId != null && costRatio != null) {
                        coefficientMap.computeIfAbsent(objectTypeId, k -> new ArrayList<>())
                                .add(new CoefficientEntry(costRatio.doubleValue(), validTargetParentId));
                    }
                }
            } catch (Exception ignored) {
                // 跳过结构不符合预期的表
            }
        }

        // 3. 子类继承父类系数及上下文（如 ternary 继承 cathode_material 的系数及 battery_cell 上下文）
        List<Map<String, Object>> objectTypes = jdbcTemplate.queryForList(
                "SELECT id, parent_object_type AS parentType FROM object_types WHERE parent_object_type IS NOT NULL"
        );
        for (Map<String, Object> ot : objectTypes) {
            String childId = (String) ot.get("id");
            String parentId = (String) ot.get("parentType");
            if (!coefficientMap.containsKey(childId) && parentId != null && coefficientMap.containsKey(parentId)) {
                coefficientMap.put(childId, new ArrayList<>(coefficientMap.get(parentId)));
            }
        }

        return coefficientMap;
    }

    /**
     * 获取边的传导系数。根据组成项上下文验证：系数仅在目标类型属于该系数的有效体系时生效，
     * 否则返回 Optional.empty() 表示该边无系数数据（需做定性模糊传导）。
     */
    private Optional<Double> getEdgeCoefficient(
            String sourceTypeId, String targetTypeId,
            Map<String, List<CoefficientEntry>> coefficientMap,
            Map<String, String> parentTypeMap) {
        List<CoefficientEntry> entries = coefficientMap.get(sourceTypeId);
        if (entries == null || entries.isEmpty()) return Optional.empty();

        String targetParent = parentTypeMap.get(targetTypeId);
        for (CoefficientEntry entry : entries) {
            if (targetTypeId.equals(entry.validTargetParentId)
                    || (targetParent != null && targetParent.equals(entry.validTargetParentId))) {
                return Optional.of(entry.coefficient);
            }
        }
        return Optional.empty();
    }

    /**
     * 获取对象类型的父类型映射。
     */
    private Map<String, String> queryParentTypeMap() {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT id, parent_object_type AS parentType FROM object_types WHERE parent_object_type IS NOT NULL"
        );
        Map<String, String> map = new HashMap<>();
        for (Map<String, Object> row : rows) {
            map.put((String) row.get("id"), (String) row.get("parentType"));
        }
        return map;
    }



    /**
     * 判断对象类型是否当前无法获取价格数据（需外部数据源补充）。
     */
    private boolean isDataUnavailableObjectType(String objectTypeId) {
        return "new_energy_vehicle".equals(objectTypeId);
    }
}
