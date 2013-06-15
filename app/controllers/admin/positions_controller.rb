# encoding: utf-8
class Admin::PositionsController < Admin::Common

  #左侧导航样式
  before_filter do
    @css_admin_position = true
  end

  #位置列表
  def index
	@css_position_list = true
    @positions = Position.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end


  #新的位置
  def new
    @position = Position.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @position }
    end
  end

  def edit
    @position = Position.find(params[:id].to_i)
  end


  def create
    @position = Position.new(params[:position])
    if @position.save
      redirect_to action: 'index', notice: '创建成功!'
    else
      render 'new'
    end
  end


  def update
    @position = Position.find(params[:id].to_i)

    respond_to do |format|
      if @position.update_attributes(params[:position])
        format.html { redirect_to admin_positions_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @position = Position.find(params[:id].to_i)
	if @position.present?
	  @position.destroy
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
      position = Position.find(id.to_i)
	  if position.present?
	    position.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end


  #ajax 设置状态
  def ajax_set_state
	@position = Position.find(params[:id].to_i)
	if @position.present?
	  @position.update_attribute(:state, params[:type])
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
