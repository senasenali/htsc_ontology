package com.ontology.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("knowledge_base")
public class KnowledgeBase {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;

    private String content;

    private String sourceType;

    private String sourceName;

    private String authors;

    private LocalDateTime entryDate;

    private String projectId;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
