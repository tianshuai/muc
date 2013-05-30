# encoding: utf-8
class HomeController < ApplicationController

  #首页
  def index

  end


  #关于
  def about

  end

  #帮助
  def help
    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @users }
    end
  end


end
