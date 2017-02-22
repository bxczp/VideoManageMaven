<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>累计视频播放统计</title>
<script src="${pageContext.request.contextPath}/echarts/source/echarts.js"></script>

<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/artdialog/ui-dialog.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap-theme.css">
<script src="${pageContext.request.contextPath}/bootstrap3/js/jQuery.min.js"></script>
<script src="${pageContext.request.contextPath}/bootstrap3/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/artdialog/dialog.js"></script>

<script type="text/javascript">
    require.config({
        paths: {
            echarts: '../echarts/dist'
        }
    });

    require(
        [
            'echarts',
            'echarts/chart/bar',
            'echarts/chart/line'
        ],
        function (ec) {
            var myChart = ec.init(document.getElementById('main'));
//             var ecConfig = require('echarts/config');
            var option = {
                title: {
                    text: '',
                    x: 'center'
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: [''],
                    y: "bottom"
                },
                toolbox: {
                    show: true, //是否显示工具箱
                    feature: {
                        mark: { show: true },
                        dataView: { show: true, readOnly: false },
                        magicType: { show: true, type: ['line', 'bar'] },
                        restore: { show: true },
                        saveAsImage: { show: true }
                    }
                },
                xAxis: [{
                    type: 'category',
                    data: []
                }],
                yAxis: [{
                    type: 'value'
                }
                    ],
                series: []
            };

            myChart.showLoading({
                text: '正在努力的读取数据中...'
            });
            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/chart/getAddUp.do',
                data: {},
                success: function(data) {
                 var data = eval ('(' + data + ')');
                 var legendData=[];
                 var xAxisData=[];
                 var seriesData=[];
                 if(data!=null && data["series"].length>0){
                     legendData=data["legen"];
                     xAxisData=data["axis"];
                     for(var i=0,len=data["series"].length;i<len;i++){
                         seriesData.push({
                             "name":legendData[i],
                             "type":"line",
                             "data":data["series"][i]
                         });
                     }
                 }
                 option.title.text="累计播放次数";
                 option.legend.data=legendData;
                 option.xAxis[0]["data"]=xAxisData;

                 myChart.setOption(option);
                 myChart.setSeries(seriesData);
                },

                error:function(){
                    //数据接口异常处理
                    var legendData=[''];
                    var xAxisData=[''];
                    var seriesData = [
                            {
                                name:'',
                                type: 'line',
                                data: [0]
                            }
                    ];
                    option.legend.data=legendData;
                    option.xAxis[0]["data"]=xAxisData;

                    myChart.setOption(option);
                    myChart.setSeries(seriesData);
                },
                complete:function(){
                    //不管数据接口成功或异常，都终于载入提示
                    //停止动画载入提示
                    myChart.hideLoading(); 
                }
            });
        }
    );
</script>

</head>
<body>

<jsp:include page="mainTemp.jsp"></jsp:include>

<div id="main" style="height:500px;padding:10px;"></div>

<div class="row">
    <div class="col-md-1 col-md-offset-10">
        <button class="btn btn-primary" onclick="javascript:window.location.href='${pageContext.request.contextPath}/chart/getAddUpExcel.do'">导出数据</button>
    </div>
</div>

</body>
</html>