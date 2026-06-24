package com.ontology.mcp.service;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Service
public class KnowledgeBaseMcpService {

    @Autowired
    private JdbcTemplate jdbc;

    /**
     * Save a knowledge base entry with its node references.
     */
    public String saveEntry(String title, String content, String sourceType,
                            String sourceName, String authors, String entryDate,
                            String refsJson, String projectId) {
        final String pid = (projectId == null || projectId.isBlank()) ? "project_public" : projectId;

        try {
            // 1. Insert into knowledge_base
            String sql = "INSERT INTO knowledge_base (title, content, source_type, source_name, " +
                    "authors, entry_date, project_id, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbc.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, title);
                ps.setString(2, content != null ? content : "");
                ps.setString(3, sourceType != null ? sourceType : "other");
                ps.setString(4, sourceName != null ? sourceName : "");
                ps.setString(5, authors != null ? authors : "");
                if (entryDate != null && !entryDate.isBlank()) {
                    ps.setTimestamp(6, Timestamp.valueOf(LocalDateTime.parse(entryDate.replace("T", " ").substring(0, 19))));
                } else {
                    ps.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
                }
                ps.setString(7, pid);
                return ps;
            }, keyHolder);

            Number docId = keyHolder.getKey();
            if (docId == null) {
                return "Error: Failed to get generated key";
            }

            // 2. Insert refs
            long finalDocId = docId.longValue();
            int refCount = 0;
            if (refsJson != null && !refsJson.isBlank()) {
                JSONArray refs = JSON.parseArray(refsJson);
                for (int i = 0; i < refs.size(); i++) {
                    JSONObject ref = refs.getJSONObject(i);
                    String refSql = "INSERT INTO knowledge_base_ref (doc_id, ref_object_type_id, " +
                            "ref_instance_id, instance_name, created_at) VALUES (?, ?, ?, ?, NOW())";
                    jdbc.update(refSql,
                            finalDocId,
                            ref.getString("objectTypeId"),
                            ref.getString("instanceId"),
                            ref.getString("instanceName")
                    );
                    refCount++;
                }
            }

            return "Successfully created knowledge base entry \"" + title + "\" (ID: " + docId + ") with " + refCount + " node reference(s).";

        } catch (Exception e) {
            return "Error creating knowledge base entry: " + e.getMessage();
        }
    }
}
