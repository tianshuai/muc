# encoding: utf-8
class UsersController < ApplicationController

  #需要登录
  before_filter :signed_in_user, only: [ :edit, :update, :edit_profile, :edit_pwd ]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page => params[:page], :per_page => 100)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id].to_i)
    if @user.present?
      render 'show'
    else
      redirect_to action: 'index'
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id].to_i)
  end

  # POST /users
  # POST /users.json
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

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id].to_i)

    if @user.update_attributes(params[:user])
    flash[:success] = "更新成功!"
    sign_in @user
    redirect_to @user
    else
      render 'edit'
    end

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id].to_i)
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  #修改个人资料
  #基本信息
  def edit_profile
    @user = current_user
    render 'edit'
  end

  #修改密码
  def edit_pwd
    @user = current_user
    
  end

  #更新密码
  def update_pwd
    if current_user.update_attributes(params[:user])
      flash[:success] = "更新成功!"
      sign_in @user
    else
      flash[:error] = '更新失败!'
    end 

  end

end
