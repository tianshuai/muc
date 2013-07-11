# encoding: utf-8
class MailRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  #ID自增
  auto_increment :id

  ##验证
  validates_presence_of :mail
  validates :mail,                                length: { minimum: 2, maximum: 50 }

  validates_presence_of :mark,				  	  message: '没有唯一标识'

  ##常量
  #状态
  STATE={
    #禁用
  	no: 0,
    #生效
    ok: 1
  }

  #类型
  TYPE = {
    #找回密码
    find_pwd: 1,
    # 未定义
    other: 2
  }

  ##属性
  field :mail,             	  type: String
  #类型
  field :type,                type: Integer,  default: TYPE[:find_pwd]
  #状态
  field :state,               type: Integer,  default: STATE[:ok]
  #唯一标识
  field :mark,    	  		  type: String

  ##索引
  index({ mail: 1 }, { background: true })
  index({ mark: 1 }, { background: true })

  ##
  #过滤

  
end
