package com.bx.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {

     public static String formatDate(Date date, String format) {
          String result = "";
          SimpleDateFormat sdf = new SimpleDateFormat(format);
          if (date != null) {
               result = sdf.format(date);
          }
          return result;
     }

     public static Date formatString(String str, String format) throws Exception {
          if (StringUtil.isEmpty(str)) {
               return null;
          }
          SimpleDateFormat sdf = new SimpleDateFormat(format);
          return sdf.parse(str);
     }

     public static String format(String str, String format) throws Exception {
        return DateUtil.formatDate(DateUtil.formatString(str, format), format);
     }
     public static String getCurrentDateStr() throws Exception {
          Date date = new Date();
          SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
          return sdf.format(date);
     }
}
