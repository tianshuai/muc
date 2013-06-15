# encoding: utf-8
class Admin::StaticTypesBackController < Admin::Common

  #左侧导航样式
  before_filter do
    @css_admin_static_type = true
  end

  #静态分类列表
  def index
	@css_static_type_list = true
    @static_types = StaticType.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #静态分类(学院概况)
  def introduce
	@css_introduce_list = true
    @static_types = StaticType.introduce.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #静态分类(艺术教学)
  def teach
	@css_teach_list = true
    @static_types = StaticType.teach.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end


  #静态分类(招生详情)
  def enrollment
	@css_enrollment_list = true
    @static_types = StaticType.enrollment.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #静态分类(学生工作)
  def student_serve
	@css_student_serve_list = true
    @static_types = StaticType.student_serve.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @static_type = StaticType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @static_type }
    end
  end

  def edit
    @static_type = StaticType.find(params[:id].to_i)
  end


  def create
    @static_type = StaticType.new(params[:static_type])
    if @static_type.save
      redirect_to action: 'index', notice: '创建成功!'
    else
      render 'new'
    end
  end


  def update
    @static_type = StaticType.find(params[:id].to_i)

    respond_to do |format|
      if @static_type.update_attributes(params[:static_type])
        format.html { redirect_to admin_static_types_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @static_type.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @static_type = StaticType.find(params[:id].to_i)
	if @static_type.present?
	  @static_type.destroy
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
      static_type = StaticType.find(id.to_i)
	  if static_type.present?
	    static_type.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end


  #ajax 设置状态
  def ajax_set_state
	@static_type = StaticType.find(params[:id].to_i)
	if @static_type.present?
	  @static_type.update_attribute(:state, params[:type])
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

end
