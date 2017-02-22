package com.bx.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.bx.entity.Record;
import com.bx.entity.Tag;
import com.bx.entity.User;
import com.bx.entity.Video;
import com.bx.service.RecordService;
import com.bx.service.TagService;
import com.bx.service.VideoService;
import com.bx.util.ResponseUtil;
import com.bx.util.StringUtil;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/video")
public class VideoController {

    @Resource
    private TagService tagService;

    @Resource
    private VideoService videoService;
    @Resource
    private RecordService recordService;

    /**
     * 跳转video保存界面
     * @param request
     * @return
     */
    @RequestMapping("/preSave")
    public ModelAndView preSave(HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        List<Tag> tags = tagService.getTagList(null);
        modelAndView.addObject("tags", tags);
        modelAndView.setViewName("upLoadVideo");
        return modelAndView;
    }

    /**
     * 保存video请求
     * @param video 对应的视频文件（file）
     * @param videoName 对应的视频名称
     * @param tagIds 对应的视频标签
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/save")
    public String save(String videoPath,String videoName, String[] tagIds, HttpServletRequest request)throws Exception{
        Video v = new Video(videoName, videoPath);
        Map<String, Object> map = new HashMap<>();
        if (tagIds != null && tagIds.length != 0) {
            map.put("tagIds", tagIds);
        }
        videoService.addVideo(v, map);
        return "redirect:/main/list.do";
    }

    @RequestMapping("/videoSave")
    public void videoSave(@RequestParam("video") MultipartFile video, HttpServletRequest request, HttpServletResponse response)throws Exception{
        String filePath=request.getServletContext().getRealPath("/");
        String fileName = video.getOriginalFilename();
        fileName = StringUtil.getCurrentDateToString() + "." + fileName.split("\\.")[1];
        String videoPath = "uploadVideo/" + fileName;
        video.transferTo(new File(filePath + videoPath));
        JSONObject result = new JSONObject();
        result.put("videoPath", videoPath);
        ResponseUtil.write(result, response);
    }

    /**
     * 更新video请求
     * @param video 对应的视频文件（file）
     * @param videoId 对应的原videoId
     * @param videoName 对应的视频名称
     * @param tagIds 对应的视频标签
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/update")
    public String updateVideo(String videoPath, String videoId, String videoName, String[] tagIds, HttpServletRequest request) throws Exception{
        Video oldVideo = videoService.getVideoById(Integer.parseInt(videoId));
        if (oldVideo == null) {
            return "redirect:/main/list.do";
        }
        Video v =new Video(videoName, videoPath);
        v.setVideoId(oldVideo.getVideoId());
        Map<String, Object> map = new HashMap<>();
        if (tagIds != null && tagIds.length != 0) {
            map.put("videoId", v.getVideoId());
            map.put("tagIds", tagIds);
        }
        videoService.updateVideo(v, map);
        return "redirect:/main/list.do";
    }

    /**
     * 具体展示videoId对应的video
     * @param videoId
     * @param op
     * @param request
     * @return
     */
    @RequestMapping("/show")
    public ModelAndView getShowVideo(String videoId, String op, HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        Video video = videoService.getVideoById(Integer.parseInt(videoId));
        if (video == null) {
            modelAndView.setViewName("redirect:/main/list.do");
            return modelAndView;
        }
        Map<String, Object> map = new HashMap<>();
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        map.put("userId", currentUser.getUserId());
        map.put("videoId", video.getVideoId());
        Record record = recordService.getLastedRecordByVideoId(map);
        if (record != null) {
            modelAndView.addObject("record", record);
        }
        List<Tag> videoTags = tagService.getTagListByVideoId(Integer.parseInt(videoId));
        video.setTags(videoTags);
        List<Tag> tags = tagService.getTagList(null);
        if (!videoTags.isEmpty()) {
            for(Tag tt : tags) {
                for(Tag t : videoTags) {
                    if (t.getTagId() == tt.getTagId()) {
                        tt.setChecked(true);
                    }
                }
            }
        }
        modelAndView.addObject("video", video);
        if (op.equals("edit")) {
            modelAndView.addObject("edit", true);
            modelAndView.addObject("tags", tags);
        } else {
            modelAndView.addObject("edit", false);
        }
        modelAndView.setViewName("videoShow");
        return modelAndView;
    }

    /**
     * 检查视频名称是否重复
     * @param videoName
     * @param videoId
     * @param response
     */
    @RequestMapping("/checkVideoName")
    public void checkVideoName(String videoName,String videoId, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        map.put("videoName", videoName);
        if (StringUtil.isNotEmpty(videoId)) {
            map.put("videoId", videoId);
        }
        int count = videoService.checkVideoName(map);
        JSONObject jsonObject = new JSONObject();
        if (count > 0) {
            jsonObject.put("exist", true);
        } else {
            jsonObject.put("exist", false);
        }
        try {
            ResponseUtil.write(jsonObject, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 更新视频播放次数请求
     * @param videoId
     * @param response
     */
    @RequestMapping("/updatePlayTimes")
    public void updatePalyTimes(String videoId, HttpServletResponse response) {
        int count = videoService.updatePalyTimes(Integer.parseInt(videoId));
        JSONObject jsonObject = new JSONObject();
        if (count > 0) {
            jsonObject.put("exist", true);
        } else {
            jsonObject.put("exist", false);
        }
        try {
            ResponseUtil.write(jsonObject, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除视频请求
     * @param videoId
     * @param response
     */
    @RequestMapping("/deleteVideo")
    public void deleteVideo(String videoId, HttpServletResponse response) {
        JSONObject jsonObject = new JSONObject();
        int count = videoService.deleteVideo(Integer.parseInt(videoId));
        if (count > 0) {
            jsonObject.put("result", true);
        } else {
            jsonObject.put("result", false);
        }
        try {
            ResponseUtil.write(jsonObject, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 发布视频请求
     * @param videoId
     * @param response
     */
    @RequestMapping("/publishVideo")
    public void publishVideo(String videoId, HttpServletResponse response) {
        JSONObject jsonObject = new JSONObject();
        int count = videoService.updatePublishVideo(Integer.parseInt(videoId));
        if (count > 0) {
            jsonObject.put("result", true);
        } else {
            jsonObject.put("result", false);
        }
        try {
            ResponseUtil.write(jsonObject, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 撤销发布视频请求
     * @param videoId
     * @param response
     */
    @RequestMapping("/withdrawVideo")
    public void withdrawVideo(String videoId, HttpServletResponse response) {
        JSONObject jsonObject = new JSONObject();
        int count = videoService.updateWithdrawVideo(Integer.parseInt(videoId));
        if (count > 0) {
            jsonObject.put("result", true);
        } else {
            jsonObject.put("result", false);
        }
        try {
            ResponseUtil.write(jsonObject, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
