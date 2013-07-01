# encoding: utf-8
module PostsHelper

  #当前位置判断（分类：mark）
  def path_cate(post,cate,type=1)
    case type
    when 1
      t_name = '学院新闻'
      t_url = posts_path
    when 2
      t_name = '中国民族美术'
      t_url = books_path
    end

    if post.present?
	  str = "#{link_to(t_name, t_url)} > #{link_to(post.category.name, {action: 'list', mark: post.category.mark })} > #{post.title}"
    else
	  if cate.present?
	    str = "#{link_to(t_name, t_url)} > #{cate.name}"
	  else
	    str = t_name
	  end
    end
	return str	
  end

  #当前位置判断（分类：mark）
  def path_load(post,cate,mark)
    case mark
    when 'student_serve'
      t_name = '学生工作'
      t_url = student_servies_path
    when ''

    end

    if post.present?
	  str = "#{link_to(t_name, t_url)} > #{post.title}"
    else
	  if cate.present?
	    str = "#{cate.name}"
	  else
	    str = t_name
	  end
    end
	return str	
  end

end
