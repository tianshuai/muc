# encoding: utf-8
##分类表
class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  #ＩＤ自增
  auto_increment :id, seed: 1

  #类型
  TYPE = {
    #新闻
    news: 1,
    #作品
    art: 2,
    #丛书
    book: 3,
	# 师资
	teacher: 4,
	# 其它
    common: 10
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
  scope :news,                -> { where(type: TYPE[:news]) }
  #作品
  scope :arts,                -> { where(type: TYPE[:art]) }
  #书籍
  scope :books,               -> { where(type: TYPE[:book]) }
  # 师资
  scope :teachers,			  -> { where(type: TYPE[:teacher]) }
  scope :commons,			  -> { where(type: TYPE[:common]) }

  #正常
  scope :normal,              -> { where(state: STATE[:ok]) }             
  #推荐
  scope :is_stick,            -> { where(stick: STICK[:ok]) }
  #排序
  scope :order_b,			  -> { asc(:order) }

  
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
	when 1  then '新闻'
	when 2  then '作品'
    when 3  then '书籍'
	when 4	then '师资'
	when 10 then '通用'
	else
	end
  end

  #分类列表数组(type:1,新闻类；2.作品;3.书籍;4.师资;10.通用)
  def self.category_arr(type=1)
	return self.news.normal.order_b if type==1
	return self.arts.normal.order_b if type==2
    return self.books.normal.order_b if type==3
    return self.teachers.normal.order_b if type==4
    return self.commons.normal.order_b if type==10
	return []
  end



  #私有方法
  private
  

  def abc

  end

end
