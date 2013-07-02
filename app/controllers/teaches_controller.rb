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

  #列表展示页
  def show
	mark = params[:mark]
    @static = Static.find_by(mark: mark)
    respond_to do |format|
	  if @static.present?
		case mark
		when 'student_art'
		  @arts = Post.arts.published.normal.recent.paginate(:page => params[:page], :per_page => 20)
		end
        format.html # show.html.erb
        format.json { render json: @static }
	  else
	    flash[:error] = "网页不存在!"
		return redirect_to root_path
	  end
    end
  end

  #作品展示页
  def art
	@post = Post.find(params[:id].to_i)
    respond_to do |format|
	  if @post.present?
		if @post.forbid?
		  flash[:error] = "此作品已被管理员禁用!"
		  format.html { redirect_to root_path }
		end
		unless @post.published?
		  flash[:error] = "没有权限!"
		  format.html { redirect_to root_path }
		end
        format.html # show.html.erb
        format.json { render json: @post }
	  else
	    flash[:error] = "作品不存在或已删除!"
		format.html { redirect_to root_path }
	  end
    end
  end


  #新建作品
  def new_art
	@post = Post.new
  end

  #创建作品
  def create_art
    @post = Post.new(params[:post])
    respond_to do |format|
      if @post.save
        if params[:asset_ids]
          params[:asset_ids].split(',').each do |id|
            asset = Asset.find(id.to_i)
            asset.update_attributes(relateable_id: @post.id, relateable_type: @post.class.to_s) if asset.present?
          end
        end
        @success = true
        @note = "创建成功!"
        #format.html { redirect_to root_path, notice: '创建成功!' }
        format.xml { render layout: false }
      else
        @success = false
        @note = '创建失败!'
        #format.html { render action: "new_art" }
        format.xml { render layout: false }
      end
    end

  end

  #编辑作品
  def edit_art
    @post = Post.find(params[:id].to_i)
	if @post.blank?
	  flash[:error] = '作品不存在'
	  redirect_to root_path
	end
  end

  #更新作品
  def update_art
	@post = Post.find(params[:id].to_i)
    respond_to do |format|
      if @post.update_attributes(params[:post])
        @success = true
        @note = "更新成功!"
        #format.html { redirect_to root_path, notice: '创建成功!' }
        format.xml { render layout: false }
      else
        @success = false
        @note = '更新失败!'
        #format.html { render action: "new_art" }
        format.xml { render layout: false }
      end
    end
  end

  #ajax加载图片队列
  def ajax_load_img
    @asset = Asset.find(params[:asset_id].to_i)

	respond_to do |f|
      if @asset.present?
        @success = true
	    f.xml { render :ajax_load_img, layout: false }
      else
        @success = false
	    f.xml { render :ajax_load_img, layout: false } 
      end
	end
  end

  # 删除作品
  def ajax_del_art
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

  # ajax推荐／取消推荐作品
  def set_art_stick
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
