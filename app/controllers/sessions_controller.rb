# encoding: utf-8
class SessionsController < ApplicationController


  #登录
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user.present? && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in(user)
      redirect_back_or(user)
    else
      flash.now[:error] = '无效的用户名或密码' # Not quite right!
      render 'new'
    end
  end

  #注销
  def destroy
    sign_out
    flash.now[:success] = '成功退出!'
    redirect_to root_path
  end

end
