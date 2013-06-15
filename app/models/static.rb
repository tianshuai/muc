# encoding: utf-8
class Static
  include Mongoid::Document
  include Mongoid::Timestamps

  #ＩＤ自增
  auto_increment :id

  ##关系
  has_many :assets,         dependent: :destroy,  as: :relateable
  belongs_to :user
  belongs_to :position


  ##验证
  validates_presence_of :short_title
  validates :short_title,                         length: { minimum: 2, maximum: 30 }
  validates_presence_of :title
  validates :title,                               length: { minimum: 2, maximum: 50 }
  validates_presence_of :mark,					  message: "请输入标识"
  validates_uniqueness_of :mark,				  with: /[a-z_]/,                       message: "标识必须惟一"

  validates :content,                             length: { maximum: 50000 }
  validates_presence_of :user_id,				  message: '请选择创建人'
  validates_presence_of :position_id,			  message: '请选择分类'

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
    # 未使用
    default: 1
  }

  #推荐
  STICK = {
	#未推荐
	no: 0,
	yes: 1
	}


  ##属性
  #标识唯一
  field :mark,				  type: String
  #短标题
  field :short_title,		  type: String
  field :title,               type: String
  field :content,             type: String
  field :user_id,             type: Integer
  #类型
  field :type,                type: Integer,  default: TYPE[:default]
  #分类
  field :position_id,		  type: Integer
  #状态
  field :state,               type: Integer,  default: STATE[:ok]
  #是否发布
  field :publish,             type: Integer,  default: PUBLISH[:yes]

  #查看数量
  field :view_count,    	  type: Integer,  default: 0
  #推荐
  field :stick,				  type: Integer,  default: STICK[:no]
  #手动排序
  field :order,				  type: Integer,  default: 0

  ##索引
  index({ short_title: 1 }, { background: true })
  index({ title: 1 }, { background: true })
  index({ created_at: 1 }, { background: true })
  index({ view_count: 1 }, { background: true })
  index({ position_id: 1 }, { background: true })
  index({ type: 1 }, { background: true })
  index({ mark: 1 }, { unique: true, background: true })

  ##
  #过滤
  
  #最新的
  scope :recent,				-> { desc(:_d) }
  #按手动排序
  scope :order_b,				-> { desc(:order) }
  #已发布的
  scope :published,				-> { where(publish: PUBLISH[:yes]) }
  #正常显示的
  scope :normal,				-> { where(state: STATE[:ok]) }

  #推荐的
  scope :sticked,				-> { where(stick: STICK[:yes]) }


  
end
