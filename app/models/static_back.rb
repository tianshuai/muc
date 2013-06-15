# encoding: utf-8
class StaticBack
  include Mongoid::Document
  include Mongoid::Timestamps

  #ＩＤ自增
  auto_increment :id

  ##关系
  has_many :assets,         dependent: :destroy,  as: :relateable
  belongs_to :user
  belongs_to :static_type


  ##验证
  validates_presence_of :title
  validates :title,                               length: { minimum: 2, maximum: 50 }

  validates :content,                             length: { maximum: 50000 }
  validates_presence_of :user_id,				  message: '请选择创建人'
  validates_presence_of :static_type_id,		  message: '请选择分类'

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

  #类型
  TYPE = {
    #学院概述
    introduce: 1,
    # 招生详情
    enrollment: 2,
    #学生工作
    student_serve: 3,
	#艺术教学
	teach: 4,
	#other
	other: 5
  }

  #推荐
  STICK = {
	#未推荐
	no: 0,
	yes: 1
	}


  ##属性
  field :title,               type: String
  field :content,             type: String
  field :user_id,             type: Integer
  #类型
  field :type,                type: Integer,  default: TYPE[:introduce]
  #分类
  field :static_type_id,      type: Integer
  #状态
  field :state,               type: Integer,  default: STATE[:ok]
  #是否发布
  field :publish,             type: Integer,  default: PUBLISH[:yes]

  #查看数量
  field :view_count,    	  type: Integer,  default: 0
  #推荐
  field :stick,				  type: Integer,  default: STICK[:no]

  ##索引
  index({ title: 1 }, { background: true })
  index({ created_at: 1 }, { background: true })
  index({ view_count: 1 }, { background: true })
  index({ static_type_id: 1 }, { background: true })
  index({ type: 1 }, { background: true })

  ##
  #过滤
  
  #最新的
  scope :recent,				-> { desc(:_d) }
  #已发布的
  scope :published,				-> { where(publish: PUBLISH[:yes]) }
  #正常显示的
  scope :normal,				-> { where(state: STATE[:ok]) }
  #学院概述
  scope :introduce,				-> { where(type: TYPE[:introduce]) }
  #招生详情
  scope :enrollment,			-> { where(type: TYPE[:enrollment]) }
  #学生服务
  scope :student_serve,         -> { where(type: TYPE[:student_serve]) }
  #艺术教学
  scope :teach,					-> { where(type: TYPE[:teach]) }
  #推荐的
  scope :sticked,				-> { where(stick: STICK[:yes]) }


  #类型说明
  def type_str
	case type
	when 1 then '学院概况'
	when 2 then '招生详情'
    when 3 then '学生工作'
	when 4 then '艺术教学'
	else
	end
  end

  #地址（不同分类下的内容走不同地址）
  def view_url
	if self.static_type.present?
	  case type
	  when 1 then	sprintf(CONF['introduce_url'], self.static_type.mark, self.id)
	  when 2 then	sprintf(CONF['enrollment_url'], self.static_type.mark, self.id)
	  when 3 then	sprintf(CONF['student_serve_url'], self.static_type.mark, self.id)
	  when 4 then	sprintf(CONF['education_url'], self.static_type.mark, self.id)
	  end
	else
	  CONF['domain_base']
	end
  end

  #分类列表数组(type:1,学院概况；2.招生详情;3.学生工作;4.艺术教学)
  def self.category_arr(type=1)
	return self.introduce.normal.order_b if type==1
	return self.enrollment.normal.order_b if type==2
    return self.student_serve.normal.order_b if type==3
    return self.teach.normal.order_b if type==4
	return []
  end
  
end
