# encoding: utf-8
class Block
  include Mongoid::Document
  include Mongoid::Timestamps

  #ＩＤ自增
  auto_increment :id

  ##关系
  has_one :asset,			dependent: :destroy,  as: :relateable
  belongs_to :block_space
  belongs_to :user

  ##验证
  validates_presence_of :title,					  message: '请输入标题'
  validates :title,                               length: { minimum: 2, maximum: 50, message: '大于２小于50' }

  validates :content,                             length: { maximum: 50000 }
  validates_presence_of :user_id,				  message: '请选择创建人'
  validates_presence_of :block_space_id,		  message: '请选择栏目位'

  ##常量
  #分类
  TYPE = {
    #用于图片沦换
  	image: 1,
    #文字
    text: 2
  }
  #状态
  STATE = {
    draft: 0,
    published: 1
  }

  #推荐
  STICK = {
	no: 0,
    ok: 1
  }
  
  ##属性

  #作者 
  field :user_id,				type: Integer
  #广告标题
  field :title,					type: String
  #链接地址
  field :url,					type: String
  #分类:1.用于图片沦换,　2.未定义
  field :type,					type: Integer,	default: TYPE[:image]
  
  #文字说明
  field :content,				type: String
  #所在栏目位
  field :block_space_id,		type: Integer

   #备注
  field :remark,				type: String
  #是否发布、草稿
  field :state,					type: Integer,	default: STATE[:draft]
  #排序
  field :order,					type: Integer,	default: 0
  #推荐
  field :stick,					type: Integer,	default: STICK[:no]

  ##索引
  index({ title: 1 }, { background: true })
  index({ type: 1 }, { background: true })
  index({ order: 1 }, { background: true })



  
  ##过滤
  scope :recent,		-> { desc(:_id) }
  # 已发布的
  scope :published,		-> { where(state: STATE[:published]) }
  #排序
  scope :order_b,		-> { asc(:order) }

  #过滤标题
  def title_f
    #h(self.title)
    self.title
  end

  #类型说明
  def type_str
	case self.type
	when 1 then '图片'
	when 2 then '文字'
	else
	  '未定义'
	end
  end
  
  
 private


end

