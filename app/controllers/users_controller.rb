# encoding: utf-8
class UsersController < ApplicationController

  #如果已登录，注册或登录页面则跳到首页
  before_filter :forbid_login, only: [ :new, :create ]

  #需要登录
  before_filter :signed_in_user, only: [ :edit, :update, :edit_profile, :edit_pwd, :edit_avatar ]

  # GET /users
  # GET /users.json
  def index

  end

  #个人展示
  def show
    @user = User.find(params[:id].to_i)
    if @user.present?
      render 'show'
    else
      redirect_to root_path
    end
  end

  #新用户
  def new
    @user = User.new
  end

  #创建用户
  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:success] = '注册成功!'
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  #修改个人资料
  #基本信息
  def edit_info
	@css_edit_info = true
    @user = current_user
    render 'edit_info'
  end

  #更新基本资料
  def update_info
	@css_edit_info = true
	@user = current_user
	#params.delete(params[:user][:email])
	if @user.update_attributes(params[:user])
	  flash[:success] = '更新成功!'
	  sign_in @user
	  redirect_to @user
	else
	  flash[:error] = '更新失败!'
	  render 'edit_info'
	end
  end

  #修改密码
  def edit_pwd
	@css_edit_pwd = true
    @user = current_user
    
  end

  #更新密码
  def update_pwd
	@css_edit_pwd = true
	@user = current_user
	if @user.authenticate(params[:current_password])
	  params[:user].delete :current_password
	  if current_user.update_attributes(params[:user])
		flash[:success] = "更新成功!"
		sign_in @user
	    redirect_to @user
	  else
		flash[:error] = '更新失败!'
		render 'edit_pwd'
	  end 
	else
	  @user.errors.add(:current_user,'原密码不正确!')
	  flash[:error] = '更新失败!'
	  render 'edit_pwd'
	end
  end

  #修改头像
  def edit_avatar
	@css_edit_avatar = true
  end

  #ajax 切割头像
  def ajax_avatar_form
	render layout: false
  end

  #ajax验证是否唯一
  def ajax_validate_only
	val = params[:val] || ''
	type = params[:type] || '1'
	if val.present?
	  case type
	  when '1'
	    user = User.find_by(name: val)
		if user.present?
	      result = false
		else
	  	  result = true
		end
	  when '2'
	    user = User.find_by(email: val.downcase)
		if user.present?
	      result = false
		else
	  	  result = true
		end
	  end
	else
	  result = false
	end
	render json: result.to_json
  end

end
