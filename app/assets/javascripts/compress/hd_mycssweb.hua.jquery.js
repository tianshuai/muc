/*
 * 幻灯脚本,基于jquery-1.4.4脚本库
 * ============================================================================
 * @ psd to htmll ,2011
 * @ Author: Haumy Gu
 * @ Official Website: http://www.mycssweb.com; Taobao Shop: http://divcss.taobao.com
 * ============================================================================
*/
$(function(){
	window.onload = function()
	{
		var play_num =1;
		var prev= 0;
		//设置轮播间隔时间
		var auto_time = 4000;
		//获取图片数量
		var auto_num = $(".ul_flash img").length;
		//获取图片高度
		//插入数字番号列表，并为首个列表单元添加样式
		$(".flash_diy").append("<ul class='num'></ul>");
		$(".flash_diy").append("<div class='prev_diy'></div>").append("<div class='next_diy'></div>");
		for(auto_i=1;auto_i<=auto_num;auto_i++)
		{
			$(".num").append("<li>"+auto_i+"</li>");
		};
		$(".num li:eq(0)").addClass("on");
		$(".num").width(15*auto_num).css("left",(980-(15*auto_num))/2);
		$(".ul_flash li:eq(0)").css("opacity","1");
		var zIndex = 1;
		//轮播动画
		function play(play_num)
		{
			$(".ul_flash li").eq(play_num).css("zIndex",zIndex).animate({opacity:1},800,function(){
				$(".ul_flash li:not(:eq("+play_num+"))").css("opacity",0);
			});
			$(".num li").removeClass("on").eq(play_num).addClass("on");
			zIndex ++;
		}
		auto_play = setInterval (function(){
			play(play_num)
			play_num++;
			if (play_num == auto_num)
			{
			play_num = 0;	
			}
		},auto_time)
		//鼠标事件
		$(".num li").hover(function(){
			$(".ul_flash").stop();
			auto_stop();
			play($(this).index());
			if($(this).index()==auto_num-1)
			{
				play_num=0;
			}
			else
			{
			play_num = $(this).index()+1;
			}
		},function(){
			auto_replay();
		});
		$(".flash_diy").hover(function(){
			auto_stop();
		},function(){
			auto_replay();
		});
		$(".prev_diy").click(function(){
			if ( !$(".ul_flash").is(":animated") )
			{
				if ( prev == 0 )
				{
					play_num--;
					prev = 1;
				}
				if(play_num==0)
				{
					play_num=auto_num-1;
				}
				else
				{
					play_num --;
				}
				play(play_num);
			}
		})
		$(".next_diy").click(function(){
			if ( !$(".ul_flash").is(":animated") )
			{
				if ( prev == 1 )
				{
					if(play_num==auto_num-1)
					{
						play_num=0;
					}
					else
					{
					play_num ++;
					}
					prev = 0;
				}
				play(play_num);
				if(play_num==auto_num-1)
				{
					play_num=0;
				}
				else
				{
				play_num ++;
				}
			}
		})
		//停止播放
		function auto_stop()
		{
			clearInterval(auto_play);	
		}
		//重新播放
		function auto_replay()
		{
			auto_play = setInterval (function(){
				play(play_num)
				play_num++;
				if (play_num == auto_num)
				{
				play_num = 0;	
				}
			},auto_time)
		}
	}
})
