# encoding: utf-8
##分类表
class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  #ＩＤ自增
  auto_increment :id, seed: 1

  #stuff类型,灵感、媒体（文字）
  TYPE = {
    #新闻
    news: 1,
    #作品
    art: 2,
    #未定义
    no_way: 3
  }

  #状态
  STATE = {
    #关闭
    no: 0,
    #启动
    ok: 1
  }

  #推荐
  STICK = {
    no: 0,
    ok: 1
  }


  ##关系
  has_many    :posts
  has_many    :arts


  ##属性
  field :name,                type: String
  #描述
  field :content,             type: String
  #标识
  field :mark,                type: String
  #类型
  field :type,                type: Integer,  default: TYPE[:news]
  #排序
  field :order,               type: Integer,  default: 0
  #索引
  field :index,               type: String
  #状态
  field :state,               type: Integer, default: STATE[:ok]
  #数量
  field :count,               type: Integer, default: 0
  #推荐
  field :stick,               type: Integer, default: STICK[:no]


  #新闻类
  scope :news,               -> { where(type: TYPE[:news]) }

  #正常
  scope :start,              -> { where(state: STATE[:ok]) }             
  #推荐的分类
  scope :is_stick,           -> { where(stick: STICK[:ok]) }    

  
  validates_presence_of :name,                message: "请输入名称"
  validates_presence_of :mark,                message: "请输入标识"
  validates_presence_of :type,                message: "请选择分类"
  validates_uniqueness_of :mark,              with: /[a-z_]/,                               message: "分类标识必须惟一"
  validates_numericality_of :order,           only_integer: true, message: "必须是整数"

  ##索引
  index({ name: 1 }, { background: true })
  index({ type: 1 }, { background: true })
  index({ mark: 1 }, { unique: true, background: true })
  index({ count: 1 }, { background: true })



  #类型
  def type_str
	case type
	when 1 then '新闻'
	when 2 then '作品'
	else
	end
  end

  #私有方法
  private
  

  def abc

  end

end
