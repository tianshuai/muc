# encoding: utf-8
##分类表
class Position
  include Mongoid::Document
  include Mongoid::Timestamps

  #ＩＤ自增
  auto_increment :id

  #类型
  TYPE = {
    # 备用，默认为１
    default: 1
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
  has_many    :statics

  ##属性
  field :name,                type: String
  #描述
  field :content,             type: String
  #标识
  field :mark,                type: String
  #类型
  field :type,                type: Integer,  default: TYPE[:default]
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

  #最新的
  scope :recent,				-> { desc(:_id) }
  #正常
  scope :normal,				-> { where(state: STATE[:ok]) }             
  #推荐
  scope :is_stick,				-> { where(stick: STICK[:ok]) }
  #排序
  scope :order_b,				-> { asc(:order) }

  
  validates_presence_of :name,                message: "请输入名称"
  validates_presence_of :mark,                message: "请输入标识"
  validates_uniqueness_of :mark,              with: /[a-z_]/,                               message: "分类标识必须惟一"
  validates_numericality_of :order,           only_integer: true, message: "必须是整数"

  ##索引
  index({ name: 1 }, { background: true })
  index({ type: 1 }, { background: true })
  index({ mark: 1 }, { unique: true, background: true })
  index({ count: 1 }, { background: true })


  ##
  #位置列表(用于select)
  #
  def self.select_name_options
	self.normal.recent.map{|c| [c.name,c.id]}
  end

  #私有方法
  private
  

  def abc

  end

end
