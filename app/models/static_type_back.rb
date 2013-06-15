# encoding: utf-8
##分类表
class StaticTypeBack
  include Mongoid::Document
  include Mongoid::Timestamps

  #ＩＤ自增
  auto_increment :id

  #类型
  TYPE = {
    #学院概述
    introduce: 1,
    # 招生详情
    enrollment: 2,
    #学生工作
    student_serve: 3,
	# 艺术教学
	teach: 4,
	#other
	other: 5
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
  field :type,                type: Integer,  default: TYPE[:introduce]
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


  #学院概述
  scope :introduce,				-> { where(type: TYPE[:introduce]) }
  #招生详情
  scope :enrollment,			-> { where(type: TYPE[:enrollment]) }
  #学生服务
  scope :student_serve,         -> { where(type: TYPE[:student_serve]) }
  #艺术教学
  scope :teach,					-> { where(type: TYPE[:teach]) }

  #正常
  scope :normal,				-> { where(state: STATE[:ok]) }             
  #推荐
  scope :is_stick,				-> { where(stick: STICK[:ok]) }
  #排序
  scope :order_b,				-> { asc(:order) }

  
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
	when 1 then '学院概况'
	when 2 then '招生详情'
    when 3 then '学生工作'
	when 4 then '艺术教学'
	else
	end
  end

  #分类列表数组(type:1,学院概述；2.招生详情;3.学生工作)
  def self.category_arr(type=1)
	return self.introduce.normal.order_b if type==1
	return self.enrollment.normal.order_b if type==2
    return self.student_serve.normal.order_b if type==3
    return self.teach.normal.order_b if type==4
	return []
  end



  #私有方法
  private
  

  def abc

  end

end
