# encoding: utf-8
class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  #ＩＤ自增
  auto_increment :id, seed: 100

  ##关系
  belongs_to :user


  ##验证
  validates_presence_of :title
  validates :title,                               length: { minimum: 2, maximum: 50 }

  validates :content,                             length: { maximum: 50000 }
  validates_presence_of :user_id

  ##常量
  #状态
  STATE={
    #禁用
  	no: 0,
    #生效
    ok: 1
  }

  #是否发布状态
  PUBLISH={
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
  field :publish,             type: Integer,  default: PUBLISH[:yes]

  #查看数量
  field :view_count,    	  type: Integer,  default: 0

  ##索引
  index({ title: 1 }, { background: true })
  index({ created_at: -1 }, { background: true })


  ##
  #过滤
  
  #已发布的
  scope :published,        -> { where(publish: PUBLISH[:yes]) }
  #正常显示的
  scope :normal,           -> { where(state: STATE[:ok]) }


  
end
