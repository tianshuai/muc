

﻿/*
 * 全站公共脚本,基于jquery-1.4.4脚本库
 * ==========================================================================================================
 * @ psd to html ,2013
 * @ Author: Haumy Gu,辜清明
 * @ Official Website: http://www.mycssweb.com; Taobao Shop: http://divcss.taobao.com; QQ: 15524261
 * ==========================================================================================================
*/
$(function(){
	//搜索处文本值空变化
		$(".ipt input").each(function(){
			var val = $(this).val();
			var color = $(this).css("color");
			$(this).focus(function(){
				if ($(this).val() == val)
				{
					$(this).css("color","#000").val("");	
				}
			})
			$(this).blur(function(){
				if ($(this).val() == "")
				{
					$(this).css("color",color).val(val);	
				}
			})
		})
	//院系介绍
		$(".tab td").hover(function(){
			if ( !$(this).hasClass("none") )
			{
				$(this).addClass("hover");
			}
		},function(){
			$(this).removeClass("hover");
		})
		$(".tab td").click(function(){
			if ( !$(this).hasClass("none") )
			{
				$(this).parent().parent().find("td").removeClass("on");
				$(this).addClass("on");
				$("body .tab_div").hide().eq($(this).index(".table td")).show();
			}
		})
	//师资队伍列表
		$(".ul_tech li").hover(function(){
			$(this).addClass("hover");
		},function(){
			$(this).removeClass("hover");
		})
		$(".ul_tech li").click(function(){
			$(this).siblings().removeClass("on").end().addClass("on");
			$("body .tab_div").hide().eq($(this).index()).show();
		})
})
