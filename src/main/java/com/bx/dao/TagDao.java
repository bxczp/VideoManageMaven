package com.bx.dao;

import java.util.List;
import java.util.Map;

import com.bx.entity.Tag;

public interface TagDao {

    /**
     * 获取所有的tag
     * @param map 查询查找
     * @return
     */
    public List<Tag> getTagList(Map<String,Object> map);
    /**
     * 获取videoId获取对应的所有的tag
     * @param videoId
     * @return
     */
    public List<Tag> getTagListByVideoId(int videoId);
}
