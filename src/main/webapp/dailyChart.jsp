<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>单日视频播放统计</title>

<script src="${pageContext.request.contextPath}/bootstrap3/js/jQuery.min.js"></script>
<script src="${pageContext.request.contextPath}/bootstrap3/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
<script src="${pageContext.request.contextPath}/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
<script src="${pageContext.request.contextPath}/artdialog/dialog.js"></script>

<script src="${pageContext.request.contextPath}/echarts/source/echarts.js"></script>


<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/artdialog/ui-dialog.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap-theme.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css">

<script type="text/javascript">
	$(function(){
	    $('#form_date').datetimepicker({
	        language:  'zh-CN',
	        weekStart: 1,
	        todayBtn:  1,
	        autoclose: 1,
	        todayHighlight: 1,
	        startView: 2,
	        minView: 2,
	        forceParse: 0,
	    });
	})

    require.config({
        paths: {
            echarts: '../echarts/dist'
        }
    });

    require(
        [
            'echarts',
            'echarts/chart/funnel',
            'echarts/chart/pie',
        ],
        function (ec) {
            var myChart = ec.init(document.getElementById('main'));
//             var ecConfig = require('echarts/config');                
            var option = {
                title: {
                    text: '单日播放次数分布',
                    x:"center"
                },
                tooltip: {
                    trigger: 'item',                        
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
                },
                legend: {
                    data:[],
                    y:"bottom"
                },
                calculable : true,
                toolbox: {
                    show: true,
                    feature: {
                        mark: { show: true },
                        dataView: { show: true, readOnly: false },
                        magicType: { show: true, type: ['pie', 'funnel'] },
                        restore: { show: true },
                        saveAsImage: { show: true }
                    }
                },
                series: []
            };

            // 载入动画---------------------
            myChart.showLoading({
                text: '正在努力的读取数据中...',    //loading话术
            });

            refreshDate(myChart, option);
        }
    ); 
    
    function refreshDate(myChart, option) {
        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/chart/getDaily.do',
            data:{ 'dateValue' : $('#dateValue').val() },
            success:function(data){
                var data = eval ('(' + data + ')');
                var legendData=[];
                var seriesData=[];
                if(data!=null && data["series"].length>0){
                    legendData=data["legen"];
                    seriesData.push({
//                         "name":"饼图标例3",
                        "type":"pie",
                        "radius" : '55%',   //饼图半径大小
                        "center": ['50%', '60%'],//饼图圆心位置x,y
                        "data":function(){
                            var t_data=[];
                            for(var i=0,len=data["series"].length;i<len;i++){
                                t_data.push({
                                    "name":legendData[i],
                                    "value":data["series"][i] 
                                });
                            }
                            return t_data;
                        }()
                    });
                }
                option.legend.data=legendData;
                myChart.setOption(option);
                myChart.setSeries(seriesData);
            },
            error:function(){
                var legendData=[''];
                var seriesData = [
                        {
                        "name":"错误数据",
                        "type":"pie",
                        "radius" : '55%',   //饼图半径大小
                        "center": ['50%', '60%'],//饼图圆心位置x,y
                            data: [0]
                        }
                ];
                option.legend.data=legendData;
                myChart.setOption(option);
                myChart.setSeries(seriesData);
            },
            complete:function(){
                //停止动画载入提示
                myChart.hideLoading();
            }
        });
    }
</script>

</head>
<body>

<jsp:include page="mainTemp.jsp"></jsp:include>

<div class="row">
    <div class="col-md-3 col-md-offset-1">	
	<form class="form-horizontal" >
        <fieldset>
            <legend>选择日期</legend>
            <div class="form-group">
                <div class="input-group date col-md-10" id="form_date" data-date-format="yyyy-mm-dd" data-link-field="dateValue" data-link-format="yyyy-mm-dd">
                    <input class="form-control" size="16" type="text" id="dateValue" name="dateValue" value="${ param.dateValue }" readonly="readonly" >
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </div>
            </div>
            <div class="from-group">
                <div class="col-md-2">
		            <button type="submit" class="btn btn-primary" onclick="refreshDate(myChart, option);">确认</button>
		        </div>
            </div>
        </fieldset>
    </form>

    </div>
    <div id="main" class="col-md-9"  style="height:500px;"></div>
    
    <div class="row">
    <div class="col-md-1 col-md-offset-10">
        <button class="btn btn-primary" onclick="javascript:window.location.href='${pageContext.request.contextPath}/chart/getDailyExcel.do'">导出数据</button>
    </div>
</div>
</div>

</body>
</html>