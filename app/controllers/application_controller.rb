# encoding: utf-8
class ApplicationController < ActionController::Base
  # 启动CSRF安全性功能
  protect_from_forgery

  include PublicSessionsHelper
  include PublicAuthHelper
  include PublicImgHelper
  include PublicShowHelper
end
