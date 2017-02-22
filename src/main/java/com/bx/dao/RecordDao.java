package com.bx.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.bx.entity.Record;

public interface RecordDao {
    public int addRecord(Record record);
    public List<Object> getDailyChart(Date date);
    public Record getLastedRecordByVideoId(Map<String, Object> map);
}
