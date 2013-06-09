# encoding: utf-8
class Admin::UsersController < ApplicationController

  def index
    @css_admin_user = true
    @users = User.paginate(:page => params[:page], :per_page => 30)
    render 'list'
  end

end
