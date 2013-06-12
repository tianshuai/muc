# encoding: utf-8
class IntroducesController < ApplicationController

  #导航链接样式
  before_filter do
    @css_introduce_header = true
  end



  #首页
  def index

  end

  #院系介绍
  def faculties

  end

  #领导介绍
  def leader

  end

end
