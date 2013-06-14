# encoding: utf-8
class Admin::PostsController < Admin::Common

  #左侧导航样式
  before_filter do
    @css_admin_news = true
  end

  #分类列表
  def index
    @css_admin_post_list = true
    @posts = Post.news.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  def edit
    @post = Post.find(params[:id].to_i)
  end


  def create
    @post = Post.new(params[:post])
	@post.user_id = current_user.id
    if @post.save
      if params[:asset_ids]
        p '1111111'
        p params[:asset_ids]
        params[:asset_ids].split(',').each do |id|
          asset = Asset.find(id)
          asset.update_attributes(relateable_id: @post.id, relateable_type: @post.class.to_s) if asset.present?
          p @post.class.to_s
        end
      end
      redirect_to action: 'index', notice: '创建成功!'
    else
      flash[:error] = '创建失败!'
      render 'new'
    end
  end


  def update
    @post = Post.find(params[:id].to_i)

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to admin_posts_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @post = Post.find(params[:id].to_i)
	if @post.present?
	  @post.destroy
	  @success = true
	  @notice = "删除成功!"
    else
	  @success = false
	  @notice = ' 删除失败!'
	end

    respond_to do |format|
      format.html
      format.js { render :destroy }
    end
  end

  #批量删除
  def destroy_more
	arr = params[:ids]
	arr.split(',').each do |id|
      post = Post.find(id.to_i)
	  if post.present?
	    post.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end


  #ajax 设置状态
  def ajax_set_state
	@post = Post.find(params[:id].to_i)
	if @post.present?
	  @post.update_attribute(:state, params[:type])
	  @success = true
	  @notice = '操作成功!'
	else
	  @success = false
	  @notice = '操作失败!'
    end
    respond_to do |f|
	  f.html
	  f.js { render :ajax_set_state }
    end
  end

  #ajax 设置推荐
  def ajax_set_stick
	@post = Post.find(params[:id].to_i)
	if @post.present?
	  @post.update_attribute(:stick, params[:type])
	  @success = true
	  @notice = '操作成功!'
	else
	  @success = false
	  @notice = '操作失败!'
    end
    respond_to do |f|
	  f.html
	  f.js { render :ajax_set_stick }
    end
  end

  #ajax 设置发布
  def ajax_set_publish
	@post = Post.find(params[:id].to_i)
	if @post.present?
	  @post.update_attribute(:publish, params[:type])
	  @success = true
	  @notice = '操作成功!'
	else
	  @success = false
	  @notice = '操作失败!'
    end
    respond_to do |f|
	  f.html
	  f.js { render :ajax_set_publish }
    end
  end

end
