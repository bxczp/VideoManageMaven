<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    Object currentUser = session.getAttribute("currentUser");
    if (currentUser != null) {
        response.sendRedirect(request.getContextPath() + "/main/list.do");
    }
%>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>视频管理平台</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap3/css/bootstrap-theme.css">
<script src="${pageContext.request.contextPath}/bootstrap3/js/jQuery.min.js"></script>
<script src="${pageContext.request.contextPath}/bootstrap3/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style/login.css">
<script src="${pageContext.request.contextPath}/js/login.js"></script>
</head>

<body>
<div class="container">
    <div class="row header">
        <div class="col-md-3 col-md-offset-1">
            <h2>视频管理</h2>
        </div>
        <div class="col-md-5 col-md-offset-1">

          <form class="form-horizontal" action="${pageContext.request.contextPath}/user/login.do" method="post" id="loginForm">
              <div class="form-group">
                  <label class="col-md-2 control-label">用户名</label>
                  <div class="col-md-10">
                      <input type="text" class="form-control" id="userName" name="userName" placeholder="userName">
                      <input type="hidden" name="service" value="${param.service}">
                  </div>
              </div>
              <div class="form-group">
                    <label class="col-md-2 control-label">密码</label>
                    <div class="col-md-10">
                        <input type="password" class="form-control" id="password" name="password" placeholder="Password">
                    </div>
              </div>
              <div class="form-group">
                    <font class="col-md-10 col-md-offset-2" id="error" color="red">${ error }</font>
              </div>
              <div class="form-group">
                  <div class="col-md-offset-3 col-md-4">
                      <button type="submit" class="btn btn-primary">登录</button>
                  </div>
                  <div class="col-md-offset-1 col-md-4">
                      <button type="reset" class="btn btn-info">重置</button>
                  </div>
              </div>
          </form>
        </div>
    </div>
</div>
</body>
</html>