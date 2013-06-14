/*
 *
 * ==========================================================================================================
*/
var muc = {

};

//初始化常用功能
muc.initial = function()
{
    /* 此类为hash链接 */
    $('a.ajax-hash').live('click',function(){
        var hash = this.hash && this.hash.substr(1);
        if (hash != ""){
            eval(hash + '.call(this);');
        }
        return false;
    });

    /* 此类为确认后执行的ajax操作 */
    $('a.confirm-request').live('click',function(){
        if(confirm('确认执行这个操作吗?')){
            $.get($(this).attr('href'));
        }
        return false;
    });


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


}


/**
 * 允许多附件上传
 */
muc.record_asset_ids = function(id,block_id){
    var ids = $(block_id).val();
    if (ids.length == 0){
        ids = id;
    }else{
        if (ids.indexOf(id) == -1){
            ids += ','+id;
        }
    }
    $(block_id).val(ids);
};

//移除附件id
muc.remove_asset_id = function(id,block_id){
    var ids = $(block_id).val();
    var ids_arr = ids.split(',');
    var is_index_key = lgk.in_array(ids_arr,id);
    ids_arr.splice(is_index_key,1);
    ids = ids_arr.join(',');
    $(block_id).val(ids);
};
