package com.ontology.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ontology.entity.KnowledgeBase;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface KnowledgeBaseMapper extends BaseMapper<KnowledgeBase> {

    @Select("SELECT DISTINCT ref_object_type_id FROM knowledge_base_ref WHERE ref_object_type_id IS NOT NULL")
    List<String> selectMarkedObjectTypeIds();
}
