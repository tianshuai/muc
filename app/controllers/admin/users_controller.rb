# encoding: utf-8
class Admin::UsersController < Admin::Common

  def index
    @css_admin_user = true
    @users = User.paginate(:page => params[:page], :per_page => 10)
    render 'list'
  end

end
