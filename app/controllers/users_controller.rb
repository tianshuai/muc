# encoding: utf-8
class UsersController < ApplicationController

  #如果已登录，注册或登录页面则跳到首页
  before_filter :forbid_login, only: [ :new, :create ]

  #需要登录
  before_filter :signed_in_user, only: [ :edit, :update, :edit_profile, :edit_info, :edit_pwd, :edit_avatar ]

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
	#记录当前ip
	@user.ip = current_ip
	#记录最后登录时间
	@user.last_time = Time.now.to_i
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
	  #sign_in @user
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
		#sign_in @user
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

  #重置密码(跳过输入原密码,用于找回密码)
  def update_r_pwd
	@user = User.find_by(email: params[:email])
	if @user.present?
	  if @user.update_attributes(params[:user])
		#删除mail_record表的记录
		mails = MailRecord.where(mail: @user.email)
		mails.each do |m|
		  m.destroy if m.present?
		end
		flash[:success] = "重置成功,请用新密码登录!"
	    redirect_to signin_path
	  else
	    flash[:error] = '更新失败!'
	    render 'edit_pwd'
	  end
    else
	  flash[:error] = '用户不存在!'
	    redirect_to signup_path
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
	  when '3'
	    user = User.find_by(email: val.downcase)
		if user.present?
	      result = true
		else
	  	  result = false
		end
	  end
	else
	  result = false
	end
	render json: result.to_json
  end

  #找回密码(发送邮件)
  def find_pwd
	
  end

  #发送邮件
  def send_mail
	mail = params[:email] || ''
	@user = User.find_by(email: mail.downcase)
    respond_to do |f|
		if @user.present?
		  mark = pwd_md5("#{@user.email+Time.now.to_s}")
		  #删除原有记录,不能重复
		  mails = MailRecord.where(mail: @user.email)
		  mails.each do |m|
			m.destroy if m.present?
		  end
		  MailRecord.create(
			mail: @user.email,
			mark: mark,
			type: MailRecord::TYPE[:find_pwd],
			state: 1
		  )
		  UserMailer.find_pwd(@user, mark: mark).deliver 

		  f.html { redirect_to user_go_mail_path(mark: mark), notice: '发送成功!' }
		  f.json { head :no_content }
		else
		  flash[:error] = '发送失败,邮箱不存在!'
		  f.html { render action: 'find_pwd' }
		  #f.json { render json:  status: :unprocessable_entity }
		end
	end
  end

  #去邮箱查看邮件
  def go_mail
	@mail = MailRecord.find_by(mark: params[:mark])
    respond_to do |f|
	  if @mail.present?
		f.html { render action: 'go_mail' }
	  else
		flash[:error] = '邮件记录不存在!'
		f.html { redirect_to user_send_mail_path }
	  end
	end
  end

  #重置密码
  def reset_pwd
	mark = params[:mark]
	respond_to do |f|
	  if mark.present?
	    mail_record = MailRecord.find_by(mark: mark)
		if mail_record.present?
		  if (mail_record.created_at.to_i + 1.hour.to_i) > Time.now.to_i
			@user = User.find_by(email: mail_record.mail)
			if @user.present?
		      f.html { render action: 'reset_pwd' }
			else
		      flash[:error] = '用户不存在,请重新注册或尝试登录其它已有账号!'
		  	  f.html { redirect_to signup_path }
			end

		  else
		    flash[:error] = '邮件已过期,请重新发送邮件!'
		  	f.html { redirect_to user_find_pwd_path }
		  end
		else
		  flash[:error] = '记录不存在,请重新发送邮件!'
		  f.html { redirect_to user_find_pwd_path }
		end
	  else
		flash[:error] = '参数错误,请重新发送邮件!'
		f.html { redirect_to user_find_pwd_path }
	  end
	end
  end

end
