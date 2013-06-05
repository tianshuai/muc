# encoding: utf-8
##权限的helper方法
module PublicAuthHelper

  #是否普通用户
  def default?
    return false if current_user.blank?
    return true if current_user.role_id == User::ROLE_ID[:user]
    return false
  end
  
  #是否管理员
  def admin?
    return false if current_user.blank?      
    return true if current_user.role_id == User::ROLE_ID[:admin]
    return false
  end
  #是否超级用户
  def system?
    return false if current_user.blank?      
    return true if current_user.role_id == User::ROLE_ID[:system]
    return false      
  end
  #是否编辑
  def editor?
    return false if current_user.blank?
    return true if current_user.role_id == User::ROLE_ID[:editor]
    return true if admin?
    return true if system?
    return false
  end

  
  #是否超级用户或管理员
  def admin_system?
    return false if current_user.blank?
    return true if admin?
    return true if system?    
    return false 
  end
  
  #通过ＩＤ判断是否是当前用户
  def owner?(user_id)
    return false if user_id.blank?
    return false if current_user.blank?
    return true if user_id.to_i == current_user.id
    return false

  end

  #如果未登录，跳到登录页面
  def signed_in_user
    store_location
    redirect_to signin_path, notice: "请先登录" unless signed_in?
  end

  #跳转相应页面并删除session[:return_to]
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  #跳转到：如登录页面前记录链接地址
  def store_location
    session[:return_to] = request.fullpath
  end


  #test
  def test
    puts 'tttttttttttttttttttian'
  end

end


