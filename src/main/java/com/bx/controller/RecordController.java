package com.bx.controller;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bx.entity.Record;
import com.bx.entity.User;
import com.bx.entity.Video;
import com.bx.service.RecordService;
import com.bx.service.VideoService;
import com.bx.util.ResponseUtil;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/record")
public class RecordController {
    @Resource
    private RecordService recordService;
    @Resource
    private VideoService videoService;

    /**
     * 记录用户使用记录
     * @param request
     * @param duration
     * @param videoId
     */
    @RequestMapping("/add")
    public void addRecord(HttpServletRequest request, String duration,String time, String operator, String videoId, HttpServletResponse response) {
        Video v = videoService.getVideoById(Integer.parseInt(videoId));
        if (v == null ) {
            try {
                response.sendRedirect("/main/list.do");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        String system = System.getProperty("os.name");
        String browser = request.getHeader("user-agent");
        JSONObject result = new JSONObject();
        Record record = new Record();
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        record.setUserId(currentUser.getUserId());
        record.setBrowser(browser);
        record.setDuration(Double.parseDouble(duration));
        record.setOperator(operator);
        record.setVideoId(v.getVideoId());
        record.setSystem(system);
        record.setPlayedTimes(v.getPlayedTimes());
        record.setTime(Integer.parseInt(time));
        int count = recordService.addRecord(record);
        if (count > 0 ) {
            result.put("result", true);
        } else {
            result.put("result", false);
        }
        try {
            ResponseUtil.write(result, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
