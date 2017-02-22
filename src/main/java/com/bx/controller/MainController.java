package com.bx.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.bx.entity.PageBean;
import com.bx.entity.Tag;
import com.bx.entity.Video;
import com.bx.service.TagService;
import com.bx.service.VideoService;
import com.bx.util.PageUtil;
import com.bx.util.PropertiesUtil;
import com.bx.util.ResponseUtil;
import com.bx.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/main")
public class MainController {

     @Resource
     private VideoService videoService;

     @Resource
     private TagService tagService;

     @RequestMapping("/list")
     public ModelAndView getVideoList(String page, String videoOrTagName, HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        Map<String, Object> mapForVideo = new HashMap<>();
        if (StringUtil.isEmpty(page)) {
             page = "1";
        }
        if(StringUtil.isNotEmpty(videoOrTagName)){
            modelAndView.addObject("videoOrTagName", videoOrTagName);
        }
        int pageSize;
          try {
               pageSize = Integer.parseInt(PropertiesUtil.getValue("pageSize"));
               PageBean pageBean = new PageBean(Integer.parseInt(page), pageSize);
               mapForVideo.put("videoOrTagName", StringUtil.formatLike(videoOrTagName));
               mapForVideo.put("start", pageBean.getStart());
               mapForVideo.put("size", pageBean.getPageSize());
               int totalCount = videoService.getVideoListCount(mapForVideo);
               String pageCode;
               if (StringUtil.isEmpty(videoOrTagName)) {
                   pageCode = PageUtil.genPagation(totalCount, Integer.parseInt(page), pageSize, request, null);
               } else {
                   pageCode = PageUtil.genPagation(totalCount, Integer.parseInt(page), pageSize, request, "videoOrTagName=" + videoOrTagName);
               }
               List<Video> videos = videoService.getVideoList(mapForVideo);
               for(Video video : videos ) {
                     List<Tag> tags = tagService.getTagListByVideoId(video.getVideoId());
                     video.setTags(tags);
               }
               modelAndView.addObject("videos", videos);
               modelAndView.addObject("pageCode", pageCode);
               modelAndView.setViewName("videoList");
          } catch (Exception e) {
               e.printStackTrace();
          }
		return modelAndView;
     }
}
