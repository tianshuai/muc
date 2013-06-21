# encoding: utf-8
class PostsController < ApplicationController

  #需要登录
  #before_filter :signed_in_user, only: [ :new, :create, :edit, :update ]

  #导航链接样式
  before_filter do
    @css_post_header = true
  end

  # GET /posts
  # GET /posts.json
  def index
	redirect_to action: 'list', mark: 'all'
  end

  #新闻分类
  def list
	mark = params[:mark]
	@categories = Category.category_arr(1)

	if mark == 'all'
	  @current_cate = []
	  @posts = Post.news.published.normal.order_b.recent.paginate(:page => params[:page], per_page: 10)
	else
	  @current_cate = Category.find_by(mark: mark)
	  if @current_cate.blank?
	    flash[:error] = "分类不存在!"
		return redirect_to root_path
	  end
	  @posts = @current_cate.posts.published.normal.order_b.recent.paginate(page: params[:page], per_page: 10) 
	end

  end

  #新闻展示页
  def show
    @post = Post.find(params[:id].to_i)
	@categories = Category.category_arr(1)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to @post, notice: '创建成功!'
    else
      render 'new'
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: '更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
