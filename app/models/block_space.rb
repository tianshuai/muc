# encoding: utf-8
class BlockSpace
  include Mongoid::Document
  include Mongoid::Timestamps

  #ＩＤ自增
  auto_increment :id

  ##关系
  has_many :blocks
  belongs_to :user

  ##常量
  #类型
  TYPE = {
    #图片用于大图沦换
  	image: 1,
    #文字
    text: 2
  }
  #状态(1.禁用；２.使用)
  STATE = {
    no: 0,
    ok: 1
  }

  #推荐
  STICK = {
	no: 0,
    ok: 1
}

  ##属性
  #栏目位名称
  field :name,				type: String
  #位置标识
  field :mark,				type: String
  #类型:1.图片,2.文字,3.flash,4.js代码
  field :type,				type: Integer,  default: TYPE[:image]
  #创建人
  field :user_id,			type: Integer

  field :width,				type: Integer,  default: 0
  field :height,			type: Integer,  default: 0
  #位置说明及要求
  field :position_info,     type: String

  #状态:0未使用,1使用中
  field :state,				type: Integer,	default: STATE[:ok]
  #推荐
  field :stick,				type: Integer,	default: STICK[:no]

  ##验证
  validates_presence_of			:name,		message: "请输入栏目位名称"
  validates_presence_of			:mark,		message: "请输入栏目标识"
  validates_presence_of			:mark,		message: "请输入创建人id"
  validates_uniqueness_of		:mark,		message: "位置标识必须惟一"
  validates_format_of			:mark,		with: /[a-z_]+/,	  message: "位置标识必须小写字符及下划线"

  validates_format_of			:width,		with: /\A\d{1,4}\Z/,  message: "请输入正确的格式宽度"
  validates_format_of			:height,	with: /\A\d{1,4}\Z/,  message: "请输入正确的格式高度"

  
  ##索引
  index({ name: 1 }, { background: true })
  index({ mark: 1 }, { unique: true, background: true })

  ##过滤
  scope :recent,		-> { asc(:_id) }
  #使用中的
  scope :normal,		-> { where( state: STATE[:ok]) }
  #用于大图沦换
  scope :image_loop,	-> { where( type: TYPE[:image]) }

  def type_str
      case self.type
      when 1
        return '图片'
      when 2
        return '文字'
      end
  end

  #类型说明
  def type_str
	case self.type
	when 1 then '图片'
	when 2 then '文字'
	elsle
	  '未定义'
	end
  end

  ##
  #栏目列表(用于select)
  #
  def self.block_space_name_options
	self.normal.recent.map{|c| [c.name,c.id]}
  end


end

