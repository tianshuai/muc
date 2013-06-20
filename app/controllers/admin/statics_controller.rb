# encoding: utf-8
class Admin::StaticsController < Admin::Common

  #左侧导航样式
  before_filter do
    @css_admin_static = true
  end

  #分类列表
  def index
    @css_static_list = true
    @statics = Static.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #分类列表(学院概述)
  def introduce
	@css_introduce_list = true
    @statics = Static.introduce.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #分类列表(艺术教学)
  def teach
	@css_teach_list = true
    @statics = Static.teach.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #分类列表(招生详情)
  def enrollment
	@css_enrollment_list = true
    @statics = Static.enrollment.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #分类列表(学生工作)
  def student_serve
	@css_student_serve_list = true
    @statics = Static.student_serve.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @static = Static.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @static }
    end
  end

  def edit
    @static = Static.find(params[:id].to_i)
  end


  def create
    @static = Static.new(params[:static])
	@static.user_id = current_user.id
    if @static.save
      if params[:asset_ids]
        params[:asset_ids].split(',').each do |id|
          asset = Asset.find(id.to_i)
          asset.update_attributes(relateable_id: @static.id, relateable_type: @static.class.to_s) if asset.present?
        end
      end
      redirect_to admin_statics_path, notice: '创建成功!'
    else
      flash[:error] = '创建失败!'
      render 'new'
    end
  end


  def update
    @static = Static.find(params[:id].to_i)

    respond_to do |format|
      if @static.update_attributes(params[:static])
		  if params[:asset_ids]
			params[:asset_ids].split(',').each do |id|
			  asset = Asset.find(id.to_i)
			  asset.update_attributes(relateable_id: @static.id, relateable_type: @static.class.to_s) if asset.present?
			end
		  end
        format.html { redirect_to admin_statics_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        flash[:error] = '更新失败!'
        format.html { render action: "edit" }
        format.json { render json: @static.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @static = Static.find(params[:id].to_i)
	if @static.present?
	  @static.destroy
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
      static = Static.find(id.to_i)
	  if static.present?
	    static.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end


  #ajax 设置状态
  def ajax_set_state
	@static = Static.find(params[:id].to_i)
	if @static.present?
	  @static.update_attribute(:state, params[:type])
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
	@static = Static.find(params[:id].to_i)
	if @static.present?
	  @static.update_attribute(:stick, params[:type])
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
	@static = Static.find(params[:id].to_i)
	if @static.present?
	  @static.update_attribute(:publish, params[:type])
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


  #ajax切换分类
  def ajax_change_type
	@category = (params[:category] || 0).to_i

	@type = (params[:type] || 1).to_i
	respond_to do |f|
	f.xml { render :ajax_change_type, layout: false }
	end
  end

end
