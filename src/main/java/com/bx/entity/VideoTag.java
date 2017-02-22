package com.bx.entity;

public class VideoTag {

    private int videoTagId;
    private Video video;
    private Tag tag;
    public int getVideoTagId() {
        return videoTagId;
    }
    public void setVideoTagId(int videoTagId) {
        this.videoTagId = videoTagId;
    }
    public Video getVideo() {
        return video;
    }
    public void setVideo(Video video) {
        this.video = video;
    }
    public Tag getTag() {
        return tag;
    }
    public void setTag(Tag tag) {
        this.tag = tag;
    }
}
