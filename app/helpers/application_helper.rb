# encoding: utf-8
module ApplicationHelper

  #页面标题
  def page_title(title)
    base_title = "中央民族大学美术学院"
    if title.empty?
      base_title
    else
      "#{base_title} | #{title}"
    end
  end

end
