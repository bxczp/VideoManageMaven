<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>上传视频</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/artdialog/ui-dialog.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap-theme.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/webuploader/webuploader.css" >
<script src="${pageContext.request.contextPath}/bootstrap3/js/jQuery.min.js"></script>
<script src="${pageContext.request.contextPath}/bootstrap3/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/artdialog/dialog.js"></script>

<script src="${ pageContext.request.contextPath }/webuploader/webuploader.js"></script>

<script src="${pageContext.request.contextPath}/js/uploadVideo.js"></script>

<script type="text/javascript">  
  $(function(){
    var $list=$("#thelist");
    //开始上传按钮
    var $btn =$("#ctlBtn");
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
    uploader.on( 'uploadSuccess', function( file, result ) {
        $( '#'+file.id ).find('p.state').text('已上传');
        $('#video').val(result.videoPath);
        $("#ctlBtn").hide();
    });

    uploader.on( 'uploadError', function( file ) {
        $( '#'+file.id ).find('p.state').text('上传出错');
    });
    
    uploader.on( 'uploadComplete', function( file ) {
        $( '#'+file.id ).find('.progress').fadeOut();
    });

      $btn.on( 'click', function() {  
          uploader.upload();  
        });  
  });
 </script>

</head>
<body>

<jsp:include page="mainTemp.jsp"></jsp:include>

<div class="container">
     <div class="col-md-6 col-md-offset-3">
          <form action="${pageContext.request.contextPath}/video/save.do" method="post" enctype="multipart/form-data" id="videoForm" >
              <div class="form-group">
                  <label for="name">视频名称</label>
                  <input type="text" class="form-control" id="videoName" name="videoName" placeholder="请输入视频名称">
                  <input type="hidden" id="video" name="videoPath">
              </div>
              <div class="form-group">
                  <label for="inputfile">视频上传</label>
                    <div id="uploader" class="jumbotron">
                        <div id="thelist" class="uploader-list"></div>
                        <div class="btns">
                            <div id="picker" name="video" >选择文件</div>
                            <button id="ctlBtn" style="margin-top: 10px;" class="btn btn-primary btn-lg">开始上传</button>
                        </div>
                    </div>
              </div>
              <div class="form-group">
                  <label for="name">选择视频标签</label>
              </div>
              <div class="form-group">
                  <c:forEach items="${ tags }" var="tag">
                      <label class="checkbox-inline">
                          <input type="checkbox" name="tagIds" value="${ tag.tagId }"> ${ tag.tagName }
                      </label>
                  </c:forEach>
              </div>
              <div class="form-group">
                    <font id="error" color="red">${ error }</font>
              </div>
              <button type="submit" id="submit" class="btn btn-primary">提交</button>
              <button type="button" onclick="javascript:window.history.back();" class="btn btn-info">返回</button>
          </form>
     </div>
</div>

</body>
</html>