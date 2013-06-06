# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  include PublicSessionsHelper
  include PublicAuthHelper
  include PublicImgHelper
  include PublicShowHelper
end
