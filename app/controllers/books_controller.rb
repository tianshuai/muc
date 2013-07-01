# encoding: utf-8
class BooksController < ApplicationController

  #导航链接样式
  before_filter do
    @css_book_header = true
  end


  #首页
  def index
	redirect_to action: 'list', mark: 'all'
  end


  #列表页
  def list
	mark = params[:mark]
	@categories = Category.category_arr(3)

	if mark == 'all'
	  @current_cate = []
	  @posts = Post.books.published.normal.order_b.recent.paginate(:page => params[:page], per_page: 10)
	else
	  @current_cate = Category.find_by(mark: mark)
	  if @current_cate.blank?
	    flash[:error] = "分类不存在!"
		return redirect_to root_path
	  end
	  @posts = @current_cate.posts.published.normal.order_b.recent.paginate(page: params[:page], per_page: 10) 
	end

  end

  #图片展示页
  def show
    @post = Post.find(params[:id].to_i)
	@categories = Category.category_arr(3)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end


end
