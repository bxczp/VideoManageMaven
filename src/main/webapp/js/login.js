$(function(){
	function checkForm() {
		var userName = $('#userName').val();
		var password = $('#password').val();
		if (userName == null || userName == '')
		{
			$('#error').html('用户名不能为空');
			//表单不提交
			return false;
		}
		if (password == null || password == '')
		{
			$('#error').html('密码不能为空');
			return false;
		}
		//提交表单
		return true;
	}
	$('#loginForm').submit(function() {
		return checkForm();
	});
});