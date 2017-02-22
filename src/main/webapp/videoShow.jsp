<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>视频详情</title>
<script src="${pageContext.request.contextPath}/ckplayer/ckplayer.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/videoShow.css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/artdialog/ui-dialog.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap-theme.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/webuploader/webuploader.css" >
<script src="${pageContext.request.contextPath}/bootstrap3/js/jQuery.min.js"></script>
<script src="${pageContext.request.contextPath}/bootstrap3/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/artdialog/dialog.js"></script>

<script src="${ pageContext.request.contextPath }/webuploader/webuploader.js"></script>

<script src="${pageContext.request.contextPath}/js/editVideo.js"></script>

<script type="text/javascript">
//修改 视频源 的内容
function handleVideo(){
    var video = $('#video');
    var videoPath = $('#videoPath');
    videoPath.val('');
}

// webuploader 上传
$(function(){
    var $list=$("#thelist");
    var $btn =$("#ctlBtn");   //开始上传  
    var uploader = WebUploader.create({
        // swf文件路径
        swf: '${pageContext.request.contextPath}/webuploader/Uploader.swf',
        // 文件接收服务端。
        server: '${pageContext.request.contextPath}/video/videoSave.do',
        // 选择文件的按钮。可选。
        // 内部根据当前运行是创建，可能是input元素，也可能是flash.
        pick: '#picker',
        // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
        resize: false,
       accept: {  
           title: 'Video',  
           extensions: 'flv,mp4',  
           mimeTypes: 'video/*'  
       },  
       method:'POST',
       // 设置文件上传域的name
       fileVal: 'video',
       // 设置文件上传大小 （200M）另外 在 spring-mvc 文件中也有设置
       fileSingleSizeLimit: 200000000
    });
    // 当有文件被添加进队列的时候
    uploader.on( 'fileQueued', function( file ) {
        $list.append( '<div id="' + file.id + '" class="item">' +
            '<h4 class="info">' + file.name + '</h4>' +
            '<p class="state">等待上传...</p>' +
        '</div>' );
        $("#picker").hide();
    });
    // 文件上传过程中创建进度条实时显示。
    uploader.on( 'uploadProgress', function( file, percentage ) {
        var $li = $( '#'+file.id ),
            $percent = $li.find('.progress .progress-bar');

        // 避免重复创建
        if ( !$percent.length ) {
            $percent = $('<div class="progress progress-striped active">' +
              '<div class="progress-bar" role="progressbar" style="width: 0%">' +
              '</div>' +
            '</div>').appendTo( $li ).find('.progress-bar');
        }
        $li.find('p.state').text('上传中');
        $percent.css( 'width', percentage * 100 + '%' );
    });
    // 上传成功的回调事件
    uploader.on( 'uploadSuccess', function( file, result ) {
        $( '#'+file.id ).find('p.state').text('已上传');
        $('#videoPath').val(result.videoPath);
        $('#videoForm').data('changed', true);
        $("#ctlBtn").hide();
    });
    // 上传失败的回调事件
    uploader.on( 'uploadError', function( file ) {
        $( '#'+file.id ).find('p.state').text('上传出错');
    });
    // 上传完成的回调事件
    uploader.on( 'uploadComplete', function( file ) {
        $( '#'+file.id ).find('.progress').fadeOut();
    });

    // 上传视频 按钮的点击事件
    $btn.on( 'click', function() {  
        uploader.upload();  
      });

    // 检查表单的值是否改变
    $('#videoForm :input').change(function(){
        $('#videoForm').data('changed', true);
    });

});

// 删除的对话框
function showDeleteDialog(videoId) {
    dialog({
        title: '确认信息',
        content: '确认要删除这条视频吗？',
        okValue: '确定',
        ok: function () {
            $.post('${pageContext.request.contextPath}/video/deleteVideo.do', {
                'videoId': videoId
            }, function(result){
                var result = eval ('(' + result + ')');
                if (result.result)
                {
                    var d = dialog({
                        content: '刪除成功'
                    });
                    d.show();
                    setTimeout(function () {
                        d.close().remove();
                    }, 2000);
                    window.location.href='${pageContext.request.contextPath}/main/list.do';
                } else {
                    var d = dialog({
                        content: '刪除失败'
                    });
                    d.show();
                    setTimeout(function () {
                        d.close().remove();
                    }, 2000);
                    window.location.reload();
                }
            });
        },
        cancelValue: '取消',
        cancel: function () {
        }
    }).show();
}

// 发布的对话框
function showPublishDialog(videoId) {
    dialog({
        title: '确认信息',
        content: '确认要发布这条视频吗？',
        okValue: '确定',
        ok: function () {
            $.post('${pageContext.request.contextPath}/video/publishVideo.do', {
                'videoId': videoId
            }, function(result){
                var result = eval ('(' + result + ')');
                if (result.result)
                {
                    var d = dialog({
                        content: '发布成功'
                    });
                    d.show();
                    setTimeout(function () {
                        d.close().remove();
                    }, 2000);
                    $('#publishBtn').addClass('hidden');
                    $('#withdrawBtn').removeClass('hidden');
                } else {
                    var d = dialog({
                        content: '发布失败'
                    });
                    d.show();
                    setTimeout(function () {
                        d.close().remove();
                    }, 2000);
                    window.location.reload();
                }
            });
        },
        cancelValue: '取消',
        cancel: function () {
        }
    }).show();
}

// 撤销发布 的 对话框
function showWithdrawDialog(videoId) {
    dialog({
        title: '确认信息',
        content: '确认要撤销发布这条视频吗？',
        okValue: '确定',
        ok: function () {
            $.post('${pageContext.request.contextPath}/video/withdrawVideo.do', {
                'videoId': videoId
            }, function(result){
                var result = eval ('(' + result + ')');
                if (result.result)
                {
                    var d = dialog({
                        content: '撤销成功'
                    });
                    d.show();
                    setTimeout(function () {
                        d.close().remove();
                    }, 2000);
                    $('#publishBtn').removeClass('hidden');
                    $('#withdrawBtn').addClass('hidden');
                } else {
                    var d = dialog({
                        content: '撤销失败'
                    });
                    d.show();
                    setTimeout(function () {
                        d.close().remove();
                    }, 2000);
                    window.location.reload();
                }
            });
        },
        cancelValue: '取消',
        cancel: function () {
        }
    }).show();
}

</script>

</head>
<body>

<jsp:include page="mainTemp.jsp"></jsp:include>

    <div class="col-md-5 info" >
        <form class="form-horizontal" action="${pageContext.request.contextPath}/video/update.do" method="post" id="videoForm">
               <div class="form-group">
                   <label class="col-md-2 control-label">视频名称</label>
                   <div class="col-md-10">
                       <input type="text" ${ !edit ? 'readonly=readonly' : ''} id="videoName" name="videoName" class="form-control" value="${ video.videoName }">
                       <input type="hidden" name="videoId" id="videoId" value="${ video.videoId }">
                   </div>
               </div>
               <c:if test="${ edit }">
                   <div class="form-group">
                       <label class="col-md-2 control-label">视频源</label>
                       <div class="col-md-10">
                           <input type="text" class="form-control" readonly="readonly" value="${ video.videoPath }" name="videoPath" id="videoPath" >
                       </div>
                   </div>
               <div class="form-group">
                   <label class="col-md-2 control-label">更换视频</label>
                   <div class="col-md-10">
                        <div id="uploader">
                            <div id="thelist" class="uploader-list"></div>
                            <div class="btns">
                                <div id="picker" name="video" id="video" onchange="handleVideo()" >选择视频文件</div>
                                <button id="ctlBtn" style="margin-top: 10px;" class="btn btn-primary btn-lg">开始上传</button>
                            </div>
                        </div>
                   </div>
               </div>
               </c:if>
               <div class="form-group">
                   <label class="col-md-2 control-label">播放次数</label>
                   <div class="col-md-10">
                       <input type="text" class="form-control" readonly="readonly" value="${ video.playedTimes }">
                   </div>
               </div>
               <div class="form-group">
                   <label class="col-md-2 control-label">创建时间</label>
                   <div class="col-md-10">
                      <input type="text" class="form-control" readonly="readonly" value="${ video.updatedTime }">
                   </div>
               </div>
               <div class="form-group">
                   <label class="col-md-2 control-label">视频标签</label>
                   <c:choose>
                       <c:when test="${ !edit }">
                   <div class="col-md-10">
                     <c:forEach var="tag" items="${ video.tags }">
                         <span class="label label-primary">${ tag.tagName }</span>
                     </c:forEach>
                   </div>
                       </c:when>
                       <c:otherwise>
                       <div class="col-md-10">
                   <c:forEach items="${ tags }" var="tag" >
                 <label class="checkbox-inline">
                             <input type="checkbox" name="tagIds" ${ tag.checked ? 'checked' : '' } value="${ tag.tagId }"> ${ tag.tagName }
                 </label>
               </c:forEach>
           </div>
                       </c:otherwise>
                   </c:choose>
               </div>
               <div class="form-group">
                    <label class="col-md-2 control-label"></label>
                    <font id="error" color="red">${ error }</font>
               </div>
               <div class="form-group">
                    <label class="col-md-2 control-label">操作</label>
                    <div class="col-md-10">
                         <c:if test="${ !edit }">
                             <button type="button" onclick="javascript:window.location='${pageContext.request.contextPath }/video/show.do?op=edit&videoId=${video.videoId}'" class="btn btn-success btn-sm">修改</button>
                         </c:if>
                         <c:if test="${ edit }">
                             <button type="submit" class="btn btn-primary btn-sm">保存修改</button>
                             <button type="button" onclick="javascript:window.history.back();" class="btn btn-success btn-sm">取消返回</button>
                         </c:if>
                         <button type="button" class="btn btn-danger btn-sm" onclick="showDeleteDialog(${video.videoId})">删除</button>
                         <button type="button" id="publishBtn" class="btn btn-info btn-sm ${ video.isPublished == 0 ? '' : 'hidden' } " onclick="showPublishDialog(${video.videoId})">发布</button>
                         <button type="button" id="withdrawBtn" class="btn btn-warning btn-sm ${ video.isPublished == 1 ? '' : 'hidden' } " onclick="showWithdrawDialog(${video.videoId})">撤销发布</button>
                    </div>
               </div>
           </form>
    </div>
    <div id="view" class=""></div>
<script type="text/javascript">
    // clplayer 播放对象
    var flashvars={
        f:'${pageContext.request.contextPath}/${video.videoPath}',
        c:0,
        // 播放器加载后调用的js函数名称
        loaded:'loadedHandler'
    };
    var video=['${video.videoPath}->video/mp4'];
    CKobject.embed('${pageContext.request.contextPath}/ckplayer/ckplayer.swf','view','ckplayer_a1','600','400',false,flashvars,video);
    function loadedHandler(){
        // 注册 开始 事件
        CKobject.getObjectById('ckplayer_a1').addListener('play','playHandler');
    }
    // 观看视频的时间点
    var duration;
    // 观看视频的时长
    var time = 0;
    // js 计时器
    var timeOut;
    // 播放事件
    function timeHandler(t){
       duration = t;
    }
    // 格式化时间点信息
    function formatTime(countTime) {
        countTime = parseInt(countTime);
        var ms = countTime%60;  //余数 89%60==29秒
        var mis = Math.floor(countTime/60);  //分钟数
        if(mis>=60){
            var hour=Math.floor(mis/60);
            mis=Math.floor((countTime-hour*60*60)/60);
            return (hour+":"+fix(mis, 2)+":"+fix(ms, 2));
        }else if(mis>=1){
            return (fix(mis, 2)+":"+fix(ms, 2));
        }else{
            return ("00:" + fix(ms, 2));
        }
    }
    
    /* 调整显示的位数 */
    /* fix(1234, 8);  //"00001234" */
    /* fix(1234, 2);  //"1234" */
    function fix(num, length) {
        return ('' + num).length < length ? ((new Array(length + 1)).join('0') + num).slice(-length) : '' + num;
    }

    // 开始计时
    function timedCount()
    {
        time = time + 1;
        timeOut = setTimeout("timedCount()",1000);
        console.log(time);
    }

    // 停止计时
    function stopCount()
    {
        clearInterval(timeOut);
        timeOut = null;
    }
    // 新的开始事件
    function playNewHandler() {
        timedCount();
        CKobject.getObjectById('ckplayer_a1').removeListener('play','playNewHandler');
    }
    // 暂停事件
    function pauseHandler() {
        stopCount();
        CKobject.getObjectById('ckplayer_a1').addListener('play','playNewHandler');
    }
    // 开始播放的监听事件
    function playHandler(){
        timedCount();
        if ('${record}') {
            var d = dialog({
                title: '视频提示',
                content: '有记录显示你已看到' + formatTime( '${ record.duration }' ) + '，是否要跳转？',
                okValue: '确定',
                ok: function () {
                    CKobject.getObjectById('ckplayer_a1').videoSeek('${ record.duration }');
                },
                cancelValue: '取消',
                cancel: function () {
                }
            });
            d.show();
        }
        // 更新播放次数
        $.post('${pageContext.request.contextPath}/video/updatePlayTimes.do', {
            'videoId' : '${video.videoId}'
        }, function(result){
        });
        CKobject.getObjectById('ckplayer_a1').removeListener('play','playHandler');
        CKobject.getObjectById('ckplayer_a1').addListener('time','timeHandler');
        CKobject.getObjectById('ckplayer_a1').addListener('pause','pauseHandler');
    }
    // 更新record记录
    window.onbeforeunload = function(){
        if (duration > 0 ) {
            $.post('${pageContext.request.contextPath}/record/add.do', {
                'duration': duration,
                'time': time,
                'videoId': '${video.videoId}',
                'operator': "${ edit ? 'edit' : 'show' }"
            }, function(result){
            });
        }
    }
</script>

</body>
</html>