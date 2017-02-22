package com.bx.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.bx.entity.Video;
import com.bx.service.RecordService;
import com.bx.service.VideoService;
import com.bx.util.DateUtil;
import com.bx.util.ExcelUtil;
import com.bx.util.ResponseUtil;
import com.bx.util.StringUtil;

@Controller
@RequestMapping("/chart")
public class ChartController {

    @Resource
    private VideoService videoService;
    @Resource
    private RecordService recordService;
    @Resource
    private VideoService videoSevice;
    private String[] dataAddUpName;
    private int[] dataAddUpCount;
    private String[] dataDailyName;
    private int[] dataDailyCount;

    @RequestMapping("/getAddUpChart")
    public ModelAndView getAddUpChart(){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("addUpChart");
        return modelAndView;
    }

    @RequestMapping("/getDailyChart")
    public ModelAndView getDailyChart(){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("dailyChart");
        return modelAndView;
    }

    /**
     * 获取图表数据
     * @param response
     */
//    data={
//            "legen":["播放次数"],
//            "axis":['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
//            "series":[
//                [4.0, 2.9, 6.0, 21.2, 50.6, 56.7, 115.6, 102.2, 62.6, 20.0, 9.4, 3.3]
//            ]
//        };
    @RequestMapping("/getAddUp")
    public void getAddUp(HttpServletResponse response){
        List<Video> videoList = videoService.getVideoList(new HashMap<>());
        Map<String, Object> map = new HashMap<>();
        List<Object> videoNames = new ArrayList<>();
        List<Object> playedCount = new ArrayList<>();
        List<Object> playedCountArray = new ArrayList<>();
        for(Video v : videoList) {
            videoNames.add(v.getVideoName());
            playedCount.add(v.getPlayedTimes());
        }
        List<String> legens = new ArrayList<>();
        playedCountArray.add(playedCount);
        legens.add("累计播放次数");
        map.put("legen", legens);
        dataAddUpName = new String[videoNames.size()];
        for(int i = 0; i < videoNames.size(); i++) {
            dataAddUpName[i] = (String) videoNames.get(i);
        }
        dataAddUpCount = new int[playedCount.size()];
        for(int i = 0; i < playedCount.size(); i++) {
            dataAddUpCount[i] = (int) playedCount.get(i);
        }
        map.put("axis", videoNames);
        map.put("series", playedCountArray);

        try {
            ResponseUtil.write(JSON.toJSONString(map), response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //后台需要返回以下结构的json数据
//    data={
//        "legen":["访问量","订单数","购买数"],
//        "series":[4440,3220,1110]
//    }
    @RequestMapping("/getDaily")
    public void getDaily(@RequestParam(required = false)String dateValue, HttpServletResponse response){
        List<Object> list = null ;
        if (StringUtil.isEmpty(dateValue)) {
           list = recordService.getDailyChart(new Date());
        } else {
            try {
                list = recordService.getDailyChart(DateUtil.formatString(dateValue, "yyyy-MM-dd"));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        List<Integer> numList = new ArrayList<>();
        List<Object> videoNameList = new ArrayList<>();
        for(Object i : list) {
            Map<String, Object> map = (Map<String, Object>) i;
            Video v = videoService.getVideoById((int)map.get("videoId"));
            if (v == null) {
                continue;
            }
            videoNameList.add(v.getVideoName());
            numList.add(new Long((long) map.get("num")).intValue());
        }
        Map<String, Object> result = new HashMap<>();
        dataDailyName = new String[videoNameList.size()];
        for(int i = 0; i<videoNameList.size(); i++) {
            dataDailyName[i] = (String) videoNameList.get(i);
        }
        dataDailyCount = new int[numList.size()];
        for(int i = 0; i<numList.size(); i++) {
            dataDailyCount[i] = numList.get(i);
        }
        result.put("legen", videoNameList);
        result.put("series", numList);
        result.put("dateValue", dateValue);
        try {
            ResponseUtil.write(JSON.toJSONString(result), response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /**
     * 导出excel文件
     * @param response
     */
    @RequestMapping("/getAddUpExcel")
    public void getAddUpExcel(HttpServletResponse response){
        try {
            ExcelUtil.outPutExcel(response, "累计播放次数统计", "累计播放次数统计", dataAddUpName, dataAddUpCount);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @RequestMapping("/getDailyExcel")
    public void getDailyExcel(HttpServletResponse response){
        try {
            ExcelUtil.outPutExcel(response, "单日播放次数统计", "单日播放次数统计", dataDailyName, dataDailyCount);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
