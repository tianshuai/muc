# encoding: utf-8
class BooksController < ApplicationController

  #导航链接样式
  before_filter do
    @css_book_header = true
  end


  #首页
  def index
	redirect_to action: 'list'
  end

  #列表页
  def list
    @books = Post.books.published.normal.recent.paginate(:page => params[:page], per_page: 10)

  end


end
