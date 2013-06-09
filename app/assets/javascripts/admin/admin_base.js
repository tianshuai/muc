//后台左侧导航
$(function(){
	$('.nav-header').click(function(){
		var obj = $(this).next('ul');
		if(obj.is(':hidden'))
		{
			obj.show();
		}else
		{
			obj.hide();
		}
	});
})
