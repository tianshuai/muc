# encoding: utf-8
class Admin::BlockSpacesController < Admin::Common

  def index
    @css_admin_block_space = true
	@css_block_space_list = true
    @block_spaces = BlockSpace.recent.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @block_space = BlockSpace.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @block_space }
    end
  end

  def edit
    @block_space = BlockSpace.find(params[:id].to_i)
  end


  def create
    @block_space = BlockSpace.new(params[:block_space])
	@block_space.user_id = current_user.id
    if @block_space.save
      redirect_to action: 'index', notice: '创建成功!'
    else
      render 'new'
    end
  end


  def update
    @block_space = BlockSpace.find(params[:id].to_i)

    respond_to do |format|
      if @block_space.update_attributes(params[:block_space])
        format.html { redirect_to admin_block_spaces_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @block_space.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @block_space = BlockSpace.find(params[:id].to_i)
	if @block_space.present?
	  @block_space.destroy
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

  #ajax 设置状态
  def ajax_set_state
	@block_space = BlockSpace.find(params[:id].to_i)
	if @block_space.present?
	  @block_space.update_attribute(:state, params[:type])
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

  #批量删除
  def destroy_more
	arr = params[:ids]
	arr.split(',').each do |id|
      bs = BlockSpace.find(id.to_i)
	  if bs.present?
	    bs.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end


end
