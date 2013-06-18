# encoding: utf-8
class Admin::BlocksController < Admin::Common

  #左侧导航样式
  before_filter do
    @css_admin_block = true
  end

  def index
	@css_block_list = true
    @blocks = Block.recent.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @block = Block.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @block }
    end
  end

  def edit
    @block = Block.find(params[:id].to_i)
  end


  def create
    @block = Block.new(params[:block])
	@block.user_id = current_user.id
    if @block.save
      if params[:asset_id]
        #获得文件/格式
		file = params[:asset_id]
        file_temp = file.tempfile
		file_name = file.original_filename
        #上传
        result = ImageUnit::Upload.save_asset(file_temp,3)
		if result[:result]
		  @block.build_asset({
			original_file: result[:file_o_id],
			thumb_small: result[:file_s_id],
			filename: file_name,
			size: result[:size],
			format_type: result[:format]
		  }).save
		end
      end
      redirect_to admin_blocks_path, notice: '创建成功!'
    else
      render 'new'
    end
  end


  def update
    @block = Block.find(params[:id].to_i)

    respond_to do |format|
      if @block.update_attributes(params[:block])
        if params[:asset_id]
          #获得文件/格式
          file = params[:asset_id]
          file_temp = file.tempfile
          file_format = file.content_type
          file_name = file.original_filename
          #上传
          result = ImageUnit::Upload.save_asset(file_temp,file_format.split('/').last)
          if result[:result]
            @block.asset.destroy
            @block.build_asset({
              original_file: result[:file_o_id],
              thumb_small: result[:file_s_id],
              filename: file_name,
              size: result[:size],
              format_type: file_format
            }).save
          end
        end
        format.html { redirect_to admin_blocks_path, notice: '更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @block = Block.find(params[:id].to_i)
	if @block.present?
	  @block.destroy
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
	@block = Block.find(params[:id].to_i)
	if @block.present?
	  @block.update_attribute(:state, params[:type])
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
      block = Block.find(id.to_i)
	  if block.present?
	    block.destroy
	  end
	end
    respond_to do |f|
      f.html
      f.js { render :destroy_more }
    end
  end

  #ajax 设置推荐
  def ajax_set_stick
	@block = Block.find(params[:id].to_i)
	if @block.present?
	  @block.update_attribute(:stick, params[:type])
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


end
