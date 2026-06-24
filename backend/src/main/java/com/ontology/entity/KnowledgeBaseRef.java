package com.ontology.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("knowledge_base_ref")
public class KnowledgeBaseRef {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long docId;

    private String refObjectTypeId;

    private String refInstanceId;

    private String instanceName;

    private LocalDateTime createdAt;
}
