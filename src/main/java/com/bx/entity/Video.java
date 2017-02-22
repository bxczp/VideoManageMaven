package com.bx.entity;

import java.util.List;

import com.bx.util.DateUtil;

public class Video {

    private int videoId;
    private String videoName;
    private int playedTimes;
    private int isPublished;
    private int isDeleted;
    private String videoPath;
    private List<Tag> tags;
    private String updatedTime;

    public String getUpdatedTime() {
        return updatedTime;
    }

    public void setUpdatedTime(String updatedTime) throws Exception {
        updatedTime = DateUtil.format(updatedTime, "yyyy-MM-dd HH:mm:ss");
        this.updatedTime = updatedTime;
    }

    public Video(String videoName, String videoPath) {
        super();
        this.videoName = videoName;
        this.videoPath = videoPath;
    }

    public Video() {
        super();
    }
    
    public int getPlayedTimes() {
        return playedTimes;
    }
    public void setPlayedTimes(int playedTimes) {
        this.playedTimes = playedTimes;
    }

    public int getVideoId() {
        return videoId;
    }
    public void setVideoId(int videoId) {
        this.videoId = videoId;
    }
    public String getVideoName() {
        return videoName;
    }
    public void setVideoName(String videoName) {
        this.videoName = videoName;
    }
    public int getIsPublished() {
        return isPublished;
    }
    public void setIsPublished(int isPublished) {
        this.isPublished = isPublished;
    }
    public int getIsDeleted() {
        return isDeleted;
    }
    public void setIsDeleted(int isDeleted) {
        this.isDeleted = isDeleted;
    }
	public List<Tag> getTags() {
		return tags;
	}
	public void setTags(List<Tag> tags) {
		this.tags = tags;
	}

    public String getVideoPath() {
        return videoPath.replace("\\", "\\\\");
    }

    public void setVideoPath(String videoPath) {
        this.videoPath = videoPath;
    }

}
