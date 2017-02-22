<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>视频列表</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/artdialog/ui-dialog.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap-theme.css">
<script src="${pageContext.request.contextPath}/bootstrap3/js/jQuery.min.js"></script>
<script src="${pageContext.request.contextPath}/bootstrap3/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/artdialog/dialog.js"></script>

<script type="text/javascript">
// 删除对话框
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
                    window.location.reload();
                } else {
                    var d = dialog({
                        content: '删除失败'
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

//发布的对话框
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
                    $('#publishBtn'+videoId).addClass('hidden');
                    $('#withdrawBtn'+videoId).removeClass('hidden');
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
                    $('#publishBtn'+videoId).removeClass('hidden');
                    $('#withdrawBtn'+videoId).addClass('hidden');
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

<div class="container">
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <form class="form-inline" action="${pageContext.request.contextPath}/main/list.do" method="get">
                <div class="form-group">
                    <input type="text" class="form-control" id="name" value="${ videoOrTagName }" name="videoOrTagName" placeholder="请输入视频名称或标签名称">
                </div>
                <button type="submit" class="btn btn-primary">搜索</button>
                <button type="button" class="btn btn-primary" onclick="javascript:window.location='${pageContext.request.contextPath }/video/preSave.do'">上传新视频</button>
            </form>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-9 col-md-offset-2">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th></th>
                    <th>视频名称</th>
                    <th>播放次数</th>
                    <th>视频标签</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="video" items="${ videos }" varStatus="status">
                <tr>
                    <td>${ status.index + 1 }</td>
                    <td><a href="${ pageContext.request.contextPath }/video/show.do?op=show&videoId=${video.videoId}">${ video.videoName }</a></td>
                    <td>${ video.playedTimes }</td>
                    <td>
                         <c:forEach var="tag" items="${ video.tags }">
                             <span class="label label-primary">${ tag.tagName }</span>
                         </c:forEach>
                    </td>
                    <td>
                        <button type="button" onclick="javascript:window.location='${pageContext.request.contextPath }/video/show.do?op=edit&videoId=${video.videoId}'" class="btn btn-success btn-sm">修改</button>
                        <button type="button" class="btn btn-danger btn-sm deleteVideo" onclick="showDeleteDialog(${video.videoId})">删除</button>
                        <button type="button" id="publishBtn${video.videoId}" class="btn btn-info btn-sm publishVideo ${ video.isPublished == 0 ? '' : 'hidden'  }" onclick="showPublishDialog(${video.videoId})">发布</button>
                        <button type="button" id="withdrawBtn${video.videoId}" class="btn btn-warning btn-sm withdrawVideo ${ video.isPublished == 1 ? '' : 'hidden' }" onclick="showWithdrawDialog(${video.videoId})">撤銷发布</button>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<div class="container">
    <div class="row">
        <div class="col-md-5 col-md-offset-4">
               <ul class="pagination">
                   ${pageCode }
               </ul>
        </div>
    </div>
</div>


</body>
</html>
