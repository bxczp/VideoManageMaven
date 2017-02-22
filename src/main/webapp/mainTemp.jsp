<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>视频管理平台</title>

<script type="text/javascript">

function showLoginOutDialog() {
    dialog({
        title: '确认信息',
        content: '确认登出？',
        okValue: '确定',
        ok: function () {
            window.location.href='${pageContext.request.contextPath}/user/logout.do';
            this.close();
            return false;
        },
        cancelValue: '取消',
        cancel: function () {
            this.close();
            return false;
        }
    }).show();
}

</script>

</head>
<body>


<nav class="navbar navbar-inverse" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="${ pageContext.request.contextPath }/main/list.do">视频管理平台</a>
        </div>
        <div>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
	                <a href="#"  class="dropdown-toggle" data-toggle="dropdown">
	                      <span class="glyphicon glyphicon-indent-right"></span> 图表
	                      <b class="caret"></b>
	                    </a>
	                <ul class="dropdown-menu">
	                    <li><a href="${ pageContext.request.contextPath }/chart/getAddUpChart.do" >累计播放次数</a></li>
	                    <li class="divider"></li>
	                    <li><a href="${ pageContext.request.contextPath }/chart/getDailyChart.do">单日播放次数分布</a></li>
	                </ul>
                </li>
                <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    <span class="glyphicon glyphicon-user"></span> User
                    ${ currentUser.userName } <b class="caret"></b>
                </a>
                <ul class="dropdown-menu">
                    <li><a href="javascript:;" onclick="showLoginOutDialog()">登出</a></li>
                    <li class="divider"></li>
                    <li><a href="#">修改密码</a></li>
                </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>


</body>
</html>