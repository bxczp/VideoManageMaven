package com.bx.dao;

import java.util.List;
import java.util.Map;

import com.bx.entity.Video;

public interface VideoDao {

    /**
     * 根据查询条件获取所有的video
     * @param map
     * @return
     */
    public List<Video> getVideoList(Map<String,Object> map);
    /**
     * 根据查询条件获取所有video的数目
     * @param map
     * @return
     */
    public int getVideoListCount(Map<String,Object> map);
    /**
     * 添加新的video
     * @param video 添加的实体
     * @return
     */
    public int addVideo(Video video);
    /**
     * 添加video对应的tag标签
     * @param map 包含videoId 和 对应的 所有的tagId
     * @return
     */
    public int addVideoTag(Map<String,Object> map);
    /**
     * 根据videoId获取该video实体
     * @param videoId
     * @return
     */
    public Video getVideoById(int videoId);
    /**
     * 更新对应videoId的video的播放次数
     * @param videoId
     * @return
     */
    public int updatePalyTimes(int videoId);
    /**
     * 发布对应videoId的video
     * @param videoId
     * @return
     */
    public int updatePublishVideo(int videoId);
    /**
     * 撤销发布对应videoId的video
     * @param videoId
     * @return
     */
    public int updateWithdrawVideo(int videoId);
    /**
     * 删除对应videoId的video（更改标志位）
     * @param videoId
     * @return
     */
    public int deleteVideo(int videoId);
    /**
     * 检查视频名称是否重复
     * @param map
     * @return
     */
    public int checkVideoName(Map<String, Object> map);
    /**
     * 获取指定video的播放次数
     * @param videoId
     * @return
     */
    public int getPlayedTimes(int videoId);
    /**
     * 更新Video
     * @param video
     * @return
     */
    public int updateVideo(Video video);
    /**
     * 删除指定videoId的所有tag
     * @param videoId
     * @return
     */
    public int deleteVideoTag(int videoId);
}
