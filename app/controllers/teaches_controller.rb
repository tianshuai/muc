# encoding: utf-8
class TeachesController < ApplicationController

  #导航链接样式
  before_filter do
    @css_teach_header = true
  end


  #首页
  def index

  end

  #师资展示页
  def teacher
	
  end

  #列表页
  def arts
    @arts = Post.arts.published.normal.recent.paginate(:page => params[:page], per_page: 10)

  end

end
