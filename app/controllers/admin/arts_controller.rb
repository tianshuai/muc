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

  end

end
