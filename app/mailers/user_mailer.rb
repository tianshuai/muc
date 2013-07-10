# encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "test_ts@163.com"

  def find_pwd
    mail(to: "tianshuaiorc@sina.com", body:"bbbbbbbbbb", subject: "我是中国人")
  end

end
