package com.ontology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ontology.entity.KnowledgeBase;
import com.ontology.entity.KnowledgeBaseRef;
import com.ontology.mapper.KnowledgeBaseMapper;
import com.ontology.mapper.KnowledgeBaseRefMapper;
import com.ontology.project.ProjectScope;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/knowledge-base")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class KnowledgeBaseController {

    private final KnowledgeBaseMapper kbMapper;
    private final KnowledgeBaseRefMapper refMapper;

    // ── DTO for create/update with refs ──────────────────────────────────────

    @Data
    public static class KnowledgeBaseDTO {
        private String title;
        private String content;
        private String sourceType;
        private String sourceName;
        private String authors;
        private LocalDateTime entryDate;
        private List<KnowledgeBaseRef> refs;
    }

    // ── List (paginated, searchable) ─────────────────────────────────────────

    @GetMapping
    public Map<String, Object> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String projectId) {
        String pid = ProjectScope.normalize(projectId);
        Page<KnowledgeBase> pageParam = new Page<>(page, size);

        QueryWrapper<KnowledgeBase> qw = new QueryWrapper<>();
        qw.lambda().eq(KnowledgeBase::getProjectId, pid);
        if (StringUtils.hasText(search)) {
            qw.lambda().like(KnowledgeBase::getTitle, search.trim());
        }
        qw.lambda().orderByDesc(KnowledgeBase::getCreatedAt);

        IPage<KnowledgeBase> result = kbMapper.selectPage(pageParam, qw);
        List<KnowledgeBase> records = result.getRecords();

        // Batch load refs for all records in this page
        List<Long> docIds = records.stream().map(KnowledgeBase::getId).toList();
        List<KnowledgeBaseRef> allRefs = docIds.isEmpty()
                ? List.of()
                : refMapper.selectBatchByDocIds(docIds);
        Map<Long, List<KnowledgeBaseRef>> refsByDoc = allRefs.stream()
                .collect(Collectors.groupingBy(KnowledgeBaseRef::getDocId));

        List<Map<String, Object>> enhancedRecords = records.stream().map(doc -> {
            Map<String, Object> item = new HashMap<>();
            item.put("doc", doc);
            item.put("refs", refsByDoc.getOrDefault(doc.getId(), List.of()));
            return item;
        }).toList();

        Map<String, Object> data = new HashMap<>();
        data.put("records", enhancedRecords);
        data.put("total", result.getTotal());
        data.put("page", result.getCurrent());
        data.put("size", result.getSize());
        data.put("totalPages", result.getPages());

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", data);
        return response;
    }

    // ── Create (with refs) ───────────────────────────────────────────────────

    @PostMapping
    public Map<String, Object> create(
            @RequestBody KnowledgeBaseDTO dto,
            @RequestParam(required = false) String projectId) {
        // Insert main doc
        KnowledgeBase kb = new KnowledgeBase();
        kb.setTitle(dto.getTitle());
        kb.setContent(dto.getContent());
        kb.setSourceType(dto.getSourceType());
        kb.setSourceName(dto.getSourceName());
        kb.setAuthors(dto.getAuthors());
        kb.setEntryDate(dto.getEntryDate());
        kb.setProjectId(ProjectScope.normalize(projectId));
        kbMapper.insert(kb);

        // Insert refs
        if (dto.getRefs() != null) {
            for (KnowledgeBaseRef ref : dto.getRefs()) {
                ref.setDocId(kb.getId());
                ref.setId(null);
                refMapper.insert(ref);
            }
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", kb);
        return response;
    }

    // ── Get detail (with refs) ───────────────────────────────────────────────

    @GetMapping("/{id}")
    public Map<String, Object> get(@PathVariable Long id) {
        KnowledgeBase kb = kbMapper.selectById(id);
        if (kb == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("error", "not found");
            return err;
        }
        List<KnowledgeBaseRef> refs = refMapper.selectByDocId(id);

        Map<String, Object> data = new HashMap<>();
        data.put("doc", kb);
        data.put("refs", refs);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", data);
        return response;
    }

    // ── Update (with refs: delete old + insert new) ──────────────────────────

    @PutMapping("/{id}")
    public Map<String, Object> update(
            @PathVariable Long id,
            @RequestBody KnowledgeBaseDTO dto) {
        KnowledgeBase kb = kbMapper.selectById(id);
        if (kb == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("error", "not found");
            return err;
        }

        kb.setTitle(dto.getTitle());
        kb.setContent(dto.getContent());
        kb.setSourceType(dto.getSourceType());
        kb.setSourceName(dto.getSourceName());
        kb.setAuthors(dto.getAuthors());
        kb.setEntryDate(dto.getEntryDate());
        kbMapper.updateById(kb);

        // Replace refs
        refMapper.delete(new QueryWrapper<KnowledgeBaseRef>().lambda().eq(KnowledgeBaseRef::getDocId, id));
        if (dto.getRefs() != null) {
            for (KnowledgeBaseRef ref : dto.getRefs()) {
                ref.setDocId(id);
                ref.setId(null);
                refMapper.insert(ref);
            }
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", kb);
        return response;
    }

    // ── Delete ───────────────────────────────────────────────────────────────

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        kbMapper.deleteById(id);
        // Refs cascade deleted by DB
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        return response;
    }

    // ── Get by object type ───────────────────────────────────────────────────

    @GetMapping("/by-object-type/{objectTypeId}")
    public Map<String, Object> getByObjectType(@PathVariable String objectTypeId) {
        List<KnowledgeBaseRef> refs = refMapper.selectByObjectTypeId(objectTypeId);
        List<Long> docIds = refs.stream().map(KnowledgeBaseRef::getDocId).distinct().toList();
        List<KnowledgeBase> docs = kbMapper.selectBatchIds(docIds);

        Map<String, Object> data = new HashMap<>();
        data.put("docs", docs);
        data.put("refs", refs);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", data);
        return response;
    }

    // ── Marked nodes (distinct object type IDs that have any KB docs) ────────

    @GetMapping("/marked-nodes")
    public Map<String, Object> getMarkedNodes() {
        List<String> ids = kbMapper.selectMarkedObjectTypeIds();

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", ids);
        return response;
    }
}
