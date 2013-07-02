# encoding: utf-8
class StudentServiesController < ApplicationController

  #导航链接样式
  before_filter do
    @css_student_serve_header = true
  end

  #首页
  def index
	redirect_to action: 'list', mark: 'student_serve'
  end


  #列表页
  def list
	mark = params[:mark]
	@category = Category.find_by(mark: mark)

	if @category.present?
	  @posts = @category.posts.published.normal.order_b.recent.paginate(:page => params[:page], per_page: 10)
	else
	  flash[:error] = "分类不存在!"
      return redirect_to root_path
	  @posts = []
	end

  end

  #展示页
  def show
    @post = Post.find(params[:id].to_i)
	unless @post.present?
	  flash[:error] = "页面不存在!"
      return redirect_to root_path
	end
	@post.inc(:view_count, 1)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

end

