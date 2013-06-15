# encoding: utf-8
module PostsHelper

  #当前位置判断（分类：mark）
  def path_cate(post,cate)

    if post.present?
	  str = "#{link_to('学院新闻', posts_path)} > #{link_to(post.category.name, {action: 'list', mark: post.category.mark })} > #{post.title}"
    else
	  if cate.present?
	    str = "#{link_to('学院新闻', posts_path)} > #{cate.name}"
	  else
	    str = "学院新闻"
	  end
    end
	return str	
  end

end
