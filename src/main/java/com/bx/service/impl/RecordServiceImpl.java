package com.bx.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.bx.dao.RecordDao;
import com.bx.entity.Record;
import com.bx.service.RecordService;

@Service("recordService")
public class RecordServiceImpl implements RecordService{

    @Resource
    private RecordDao recordDao;

    @Override
    public int addRecord(Record record) {
        return recordDao.addRecord(record);
    }

    @Override
    public List<Object> getDailyChart(Date date) {
        return recordDao.getDailyChart(date);
    }

    @Override
    public Record getLastedRecordByVideoId(Map<String, Object> map) {
        return recordDao.getLastedRecordByVideoId(map);
    }
    
}
