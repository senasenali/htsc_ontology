package com.ontology.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ontology.entity.KnowledgeBaseRef;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface KnowledgeBaseRefMapper extends BaseMapper<KnowledgeBaseRef> {

    @Select("SELECT * FROM knowledge_base_ref WHERE doc_id = #{docId}")
    List<KnowledgeBaseRef> selectByDocId(Long docId);

    @Select("SELECT * FROM knowledge_base_ref WHERE ref_object_type_id = #{objectTypeId}")
    List<KnowledgeBaseRef> selectByObjectTypeId(String objectTypeId);

    @Select("<script>SELECT * FROM knowledge_base_ref WHERE doc_id IN <foreach item='id' collection='ids' open='(' separator=',' close=')'>#{id}</foreach></script>")
    List<KnowledgeBaseRef> selectBatchByDocIds(List<Long> ids);
}
