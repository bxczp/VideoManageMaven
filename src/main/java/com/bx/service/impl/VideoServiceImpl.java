package com.bx.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import com.bx.dao.VideoDao;
import com.bx.entity.Video;
import com.bx.service.VideoService;

@Service("videoService")
public class VideoServiceImpl implements VideoService{

    @Resource
    private VideoDao videoDao;

    @Override
    public List<Video> getVideoList(Map<String, Object> map) {
        return videoDao.getVideoList(map);
    }

    @Override
    public int getVideoListCount(Map<String, Object> map) {
        return videoDao.getVideoListCount(map);
    }

    @Override
    public int addVideo(Video video, Map<String, Object> map) {
        videoDao.addVideo(video);
        if (map.get("tagIds") != null) {
            map.put("videoId", video.getVideoId());
            videoDao.addVideoTag(map);
        }
        return video.getVideoId();
    }

    @Override
    public int addVideoTag(Map<String, Object> map) {
        return videoDao.addVideoTag(map);
    }

    @Override
    public Video getVideoById(int videoId) {
        return videoDao.getVideoById(videoId);
    }

    @Override
    public int updatePalyTimes(int videoId) {
        return videoDao.updatePalyTimes(videoId);
    }

    @Override
    public int deleteVideo(int videoId) {
        return videoDao.deleteVideo(videoId);
    }

    @Override
    public int checkVideoName(Map<String, Object> map) {
        return videoDao.checkVideoName(map);
    }

    @Override
    public int updatePublishVideo(int videoId) {
        return videoDao.updatePublishVideo(videoId);
    }

    @Override
    public int updateWithdrawVideo(int videoId) {
        return videoDao.updateWithdrawVideo(videoId);
    }

    @Override
    public int getPlayedTimes(int videoId) {
        return videoDao.getPlayedTimes(videoId);
    }

    @Override
    public int updateVideo(Video video, Map<String, Object> map) {
        videoDao.deleteVideoTag(video.getVideoId());
        if (map.get("tagIds") != null) {
            videoDao.addVideoTag(map);
        }
        return videoDao.updateVideo(video);
    }

    @Override
    public int deleteVideoTag(int videoId) {
        return videoDao.deleteVideo(videoId);
    }

}
