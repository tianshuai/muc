# encoding: utf-8
class Admin::CategoriesController < Admin::Common


  #分类列表
  def index
    @css_admin_cate = true
    @categories = Category.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

  #新的分类
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  def edit
    @categories = Category.find(params[:id].to_i)
  end


  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to action: 'index', notice: '创建成功!'
    else
      render 'new'
    end
  end


  def update
    @category = Category.find(params[:id].to_i)

    respond_to do |format|
      if @category.update_attributes(params[:post])
        format.html { redirect_to @category, notice: '更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @category = Category.find(params[:id].to_i)
	if @category.present?
	  @category.destroy
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
	@category = Category.find(params[:id].to_i)
	if @category.present?
	  @category.update_attribute(:state, params[:type])
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
