# encoding: utf-8
class HomeController < ApplicationController

  #导航链接样式
  before_filter do
    @css_index_header = true
  end



  #首页
  def index
	@posts = Post.news.published.normal.sticked.recent.limit(5)

  end


  #关于
  def about

  end

  #帮助
  def help
    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @users }
    end
  end


end
