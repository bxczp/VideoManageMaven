package com.bx.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bx.dao.TagDao;
import com.bx.entity.Tag;
import com.bx.service.TagService;

@Service("tagService")
public class TagServiceImpl implements TagService {

	@Resource
	private TagDao tagDao;

    @Override
    public List<Tag> getTagList(Map<String, Object> map) {
    	return tagDao.getTagList(map);
    }

    @Override
    public List<Tag> getTagListByVideoId(int videoId) {
        return tagDao.getTagListByVideoId(videoId);
    }

}
