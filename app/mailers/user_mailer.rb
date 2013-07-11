# encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "university_minzu@163.com"

  def find_pwd(user, options={})
	@user = user
	@url = "#{File.join(CONF['domain_base'], 'user/reset_pwd')}?mark=#{options[:mark]}"
    mail(to: user.email, subject: "中央民族大学美术学院-找回密码")
  end

end
