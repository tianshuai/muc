module SessionsHelper

  def sign_in(user)
    #permanent:cookie失效日期20年后（永久保存）
    cookies.permanent[:remember_token] = user.remember_token

    #cookies[:remember_token] = { value:   user.remember_token,
    #                        expires: 20.years.from_now.utc }
    
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_name(remember_token: cookies[:remember_token])
  end

  #注销
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  #判断是否登录状态
  def signed_in?
    !current_user.nil?
  end

end
