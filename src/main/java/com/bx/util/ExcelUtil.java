package com.bx.util;

import java.io.OutputStream;
import javax.servlet.http.HttpServletResponse;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.NumberFormat;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.Number;

public class ExcelUtil {

    public static void outPutExcel(HttpServletResponse response, String sheetName, String label00Name, String[] dataName, int[] dataCount) throws Exception {
        //获得输出流，该输出流的输出介质是客户端浏览器  
        OutputStream output=response.getOutputStream();
        response.reset();
        response.setHeader("Content-disposition","attachment;filename = temp.xls");
        response.setContentType("application/msexcel");  
        //创建可写入的Excel工作薄，且内容将写入到输出流，并通过输出流输出给客户端浏览
        //创建一个工作薄，就是整个Excel文档，
        WritableWorkbook wk=Workbook.createWorkbook(output);
        ///创建可写入的Excel工作表   两个参数分别是工作表名字和插入位置，这个位置从0开始，比如：
        WritableSheet sheet=wk.createSheet(sheetName, 0);
        sheet.mergeCells(0,0, 4,0);//单元格合并方法  
        //创建WritableFont 字体对象，参数依次表示黑体、字号12、粗体、非斜体、不带下划线、亮蓝色
        WritableFont titleFont=new WritableFont(WritableFont.createFont("黑体"),12,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,Colour.LIGHT_BLUE);  
        //创建WritableCellFormat对象，将该对象应用于单元格从而设置单元格的样式
        WritableCellFormat titleFormat=new WritableCellFormat();
        //设置字体格式
        titleFormat.setFont(titleFont);
        //设置文本水平居中对齐
        titleFormat.setAlignment(Alignment.CENTRE);
        //设置文本垂直居中对齐
        titleFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
        //设置背景颜色
        titleFormat.setBackground(Colour.GRAY_25);
        //设置自动换行
        titleFormat.setWrap(true);
        //实际上标签这里的意思就是工作表的单元格，这个单元格多种，分别对应不同的类，比如jxl.write.Boolean、jxl.write.Boolean等。
        //添加Label对象，参数依次表示在第一列，第一行，内容，使用的格式  
        Label lab00=new Label(0, 0, label00Name, titleFormat);  
        //将定义好的Label对象添加到工作表上，这样工作表的第一列第一行的内容为labelName并应用了titleFormat定义的样式  
        sheet.addCell(lab00);
        WritableCellFormat cloumnTitleFormat=new WritableCellFormat();  
        cloumnTitleFormat.setFont(new WritableFont(WritableFont.createFont("宋体"),10,WritableFont.BOLD,false));  
        cloumnTitleFormat.setAlignment(Alignment.CENTRE);  
        Label lab01=new Label(0, 1, "视频名称",cloumnTitleFormat);
        Label lab11=new Label(1, 1, "播放次数",cloumnTitleFormat);
        sheet.addCell(lab01);
        sheet.addCell(lab11);
        if (dataName != null && dataName.length != 0) {
            for(int i = 0; i< dataName.length; i++) {
                sheet.addCell(new Label(0, i + 2, dataName[i] ));
            }
        }
        //定义数字格式  
        //NumberFormat nf=new NumberFormat("0.00");
        NumberFormat nf=new NumberFormat("0"); 
        WritableCellFormat wcf=new WritableCellFormat(nf);  
        //类似于Label对象，区别Label表示文本数据，Number表示数值型数据 
        if (dataCount != null && dataCount.length != 0) {
            for(int j = 0; j< dataCount.length; j++) {
                sheet.addCell(new Number(1, j + 2, dataCount[j], wcf));
            }
        }
        //将定义的工作表输出到之前指定的介质中（这里是客户端浏览器）  
        wk.write();
        //操作完成时，关闭对象，释放占用的内存空间     
        wk.close();
    }
}
