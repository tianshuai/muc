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
	  @posts = Post.news.published.normal.order_b.recent.paginate(:page => params[:page], per_page: 20)
	else
	  @current_cate = Category.find_by(mark: mark)
	  if @current_cate.blank?
	    flash[:error] = "分类不存在!"
		return redirect_to root_path
	  end
	  @posts = @current_cate.posts.published.normal.order_b.recent.paginate(page: params[:page], per_page: 20) 
	end

  end

  #新闻展示页
  def show
    @post = Post.find(params[:id].to_i)
	unless @post.present?
	  flash[:error] = "页面不存在!"
      return redirect_to root_path
	end
	@post.inc(:view_count, 1)
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

  # ajax删除新闻
  def ajax_del_post
	@post = Post.find(params[:id].to_i)

    if @post.present?
	  if can_edit?(@post.user)
	    if @post.destroy
		  @success = true
		  @note = "删除成功!"
	    else
		  @success = false
		  @note = "删除失败!"
	    end
	  else
		@success = false
		@note = "没有权限"
      end
    else
	  @success = false
	  @note = "作品不存在!"
	end

	respond_to do |f|
	  f.xml { render layout: false }
	end
  end

  # ajax推荐／取消推荐新闻
  def set_post_stick
	@post = Post.find(params[:id].to_i)

    if @post.present?
	  if can_edit?(@post.user)
		@type = params[:type] == '0' ? 0 : 1
	    if @post.update_attribute(:stick, @type)
		  @success = true
		  @note = "操作成功!"
	    else
		  @success = false
		  @note = "操作失败!"
	    end
	  else
		@success = false
		@note = "没有权限"
      end
    else
	  @success = false
	  @note = "作品不存在!"
	end

	respond_to do |f|
	  f.xml { render layout: false }
	end
  end

end
