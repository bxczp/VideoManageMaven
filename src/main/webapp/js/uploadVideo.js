$(function(){
	var flag = true;
	function checkForm() {
		var videoName = $('#videoName').val();
		var video = $('#video').val();
		if (videoName == null || videoName == '')
		{
			$('#error').html('视频名称不能为空');
			return false;
		}
		if (video == null || video == '')
		{
			$('#error').html('视频不能为空');
			return false;
		}
		checkVideoName();
		return flag;
	}
	function checkVideoName() {
		$.post('checkVideoName.do', {
			'videoName' : $('#videoName').val()
		}, function(result) {
			var result = eval ('(' + result + ')');
			if (result.exist)
			{
				$('#error').html ('视频名称重复');
				flag = false;
			} else {
				$('#error').html ('');
				flag = true;
			}
		})
	}
	$('#videoForm').submit(function() {
		return checkForm();
	});
	$('#videoName').blur(function(){
		checkVideoName();
	});
});
