# encoding: utf-8
class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  ##关系
  belongs_to :user

  ##常量
  #状态
  STATE={
    #禁用
  	no: 0,
    #生效
    ok: 1
  }

  #是否发布状态
  PUBLISHED={
    no: 0,
    yes: 1
  }


  ##属性
  field :title,               type: String
  field :content,             type: String
  field :user_id,             type: Integer
  #类型（还未定义）
  field :type,                type: Integer,  default: 1
  #状态
  field :state,               type: Integer,  default: STATE[:ok]
  #是否发布
  field :published,           type: Integer,  default: PUBLISHED[:yes]


  ##索引
  index({ title: 1 }, { background: true })
  index({ created_at: -1 }, { background: true })


  ##
  #过滤
  
  #已发布的
  scope :is_publish,          where(published: PUBLISHED[:yes])
  #正常显示的
  scope :normal,              where(state: STATE[:ok])


  ##验证
  validates_presence_of :title,                   message: '不能为空'
  validates :title,                               length: { minimum: 2, maximum: 50, message: '长度大于4个字符且小于50个字符' }

  validates :content,                             length: { maximum: 50000, message: '长度大于5万个字符' }
  validates_presence_of :user_id,                 message: '不能为空'
  
end
