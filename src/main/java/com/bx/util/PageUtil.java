package com.bx.util;

import javax.servlet.http.HttpServletRequest;

public class PageUtil {
    public static String genPagation(int totalNum, int currentPage, int pageSize,HttpServletRequest request, String param) {
        int totalPage = totalNum % pageSize == 0 ? totalNum / pageSize : totalNum / pageSize + 1;
        if (totalPage == 0) {
            return "没有记录";
        }
        StringBuffer pageCode = new StringBuffer();
        pageCode.append("<li><a href='"+request.getContextPath()+"/main/list.do?page=1&"+ param +"'>首页</a></li>");
        if (currentPage == 1) {
            pageCode.append("<li class='disabled'><a href='#'>上一页</a></li>");
        } else {
            pageCode.append("<li><a href='"+request.getContextPath()+"/main/list.do?page=" + (currentPage - 1) + "&" + param + "'>上一页</a></li>");
        }
        for (int i = currentPage - 2; i <= currentPage + 2; i++) {
            if (i < 1 || i > totalPage) {
                continue;
            } else {
                pageCode.append("<li><a href='"+request.getContextPath()+"/main/list.do?page=" + i + "&" + param + "'>" + i + "</a></li>");
            }
        }

        if (currentPage == totalPage) {
            pageCode.append("<li class='disabled'><a href='#'>下一页</a></li>");
        } else {
            pageCode.append("<li><a href='"+request.getContextPath()+"/main/list.do?page=" + (currentPage + 1) + "&" + param + "'>下一页</a></li>");
        }
        pageCode.append("<li><a href='"+request.getContextPath()+"/main/list.do?page=" + totalPage + "&"+ param +"'>尾页</a></li>");

        return pageCode.toString();
    }

}
