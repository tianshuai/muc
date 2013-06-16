# encoding: utf-8
class TeachesController < ApplicationController

  #导航链接样式
  before_filter do
    @css_teach_header = true
  end
 
  #需要登录
  before_filter :signed_in_user, only: [ :new_art, :create_art ]

  # 加载该导航下的所属分类
  before_filter only: [:index, :show] do
	@position = Position.find_by(mark: 'teach')
	if @position.blank?
	  flash[:error] = "分类不存在!"
	  return redirect_to root_path
	end
  end

  #首页
  def index
	statics = @position.statics.published.normal.order_b
	if statics.present?
	  redirect_to action: 'show', mark: statics.first.mark
	else
	  flash[:error] = "分类不存在!"
	  return redirect_to root_path
	end
  end

  #新闻展示页
  def show
	mark = params[:mark]
    @static = Static.find_by(mark: mark)
    respond_to do |format|
	  if @static.present?
        format.html # show.html.erb
        format.json { render json: @static }
	  else
	    flash[:error] = "网页不存在!"
		return redirect_to root_path
	  end
    end
  end


  #新建作品
  def new_art
	@post = Post.new
  end

  #创建作品
  def create_art
	p 'aaaaaaaaaaaaaaaaaaaa'
  end

end
