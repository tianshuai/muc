# encoding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  #ＩＤ自增
  auto_increment :id, seed: 10000
  attr_accessible :name,:email
  attr_accessible :password, :password_confirmation, :current_password

  ##关系
  #内嵌表：用户详细信息
  embeds_one :profile
  has_many :posts,            dependent: :destroy
  has_many :arts,            dependent: :destroy
  has_many :blocks
  has_many :block_spaces



  #注册时把邮箱转换为小写字符
  before_save { |user| user.email = email.downcase }

  #创建用户登录标识(唯一随机数)
  before_save :create_remember_token

  #保护字段
  attr_protected :role_id

  #密码自动加密
  has_secure_password


  ##验证
  validates_presence_of :name,                    message: '不能为空'
  validates :name,                                length: { minimum: 4, maximum: 18, message: '长度大于4个字符且小于18个字符' }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_presence_of :email,                   message: '不能为空'
  validates :email,                               format: { with: VALID_EMAIL_REGEX,  message: '格式不正确' },
                                                  uniqueness: { case_sensitive: false, message: '已经存在!' }

  validates :password,                            length: { minimum: 6,maximum: 18, message: '长度大于6个字符且小于18个字符' },
												  unless: lambda {|u| u.password.nil? }
  validates_presence_of :password,                message: '不能为空', unless: lambda {|u| u.password.nil? }
  #validates_presence_of :password_confirmation,   message: '不能为空'

  ##常量
  #角色
  ROLE_ID={
    #user
    user: 1,
    #editor
    editor: 2,
    #admin
    admin: 7,
    #system
    system: 8

  }
  #状态
  STATE={
    #禁用
  	no: 0,
    #生效
    ok: 1
  }

  TYPE = {
    #学生
    student: 1,
    #老师
    teacher: 2,
    #公司
    company: 3
  }
  #性别
  SEX = {
    secret: 0,
    boy: 1,
    girl: 2

  }


  ##属性
  field :name,                  type: String
  field :email,                 type: String

  #密码(加密)
  field :password_digest,       type: String

  #性别(默认保密)
  field :sex,                   type: Integer,  default: SEX[:secret]

  #出生日期　
  field :birth,                 type: Integer
  #个性签名
  field :signature,             type: String
  #描述
  field :desc,                  type: String

  #用户工作类型
  field :job,                   type: String
  field :school,                type: String

  #中国，０；海外，１
  field :abroad,                type: Integer,  default: 0
  #如果不是中国，则手动添写国家
  field :country,               type: String
  #地点（省，市）
  field :province,              type: Integer,  default: 0
  field :city,                  type: Integer,  default: 0
  #详细地址
  field :address,               type: String

  #邮编
  field :zip,                   type: String
  #电话
  field :phone,                 type: String

  #权限
  field :role_id,               type: Integer,  default: ROLE_ID[:user]
  #类别
  field :type,                  type: Integer,  default: TYPE[:student]
  #状态
  field :state,					type: Integer,	default: STATE[:ok]

  #是否初次登录、
  field :first_login,           type: Integer,  default: 0

  #记忆权标
  field :remember_token,        type: String

  # 个人图片展示
  field :img,                   type: Hash,     default: {
                                                  'avatar'=> {
                                                    #小图(50*50)
                                                    's'=> '',
                                                    #中图(100*100)
                                                    'm'=> '', 
                                                    #大图(180*180)
                                                    'b'=> '', 
                                                    #类型
                                                    'type'=> ''
                                                  },
                                                  #个人页面banner
                                                  'top_banner'=> ''

                                                }


  ##索引
  index({ name: 1 }, { background: true })
  index({ email: 1 }, { unique: true, background: true })
  index({ remember_token: 1 }, { unique: true, background: true })
  index({ name: 1 }, { unique: true, background: true })


  ##过滤
  #用户排序
  scope :recent,      -> { desc(:_id) }
  #学生
  scope :students,    -> { where(type: TYPE[:student]) }


  ##
  #方法

  #性别信息
  def sex_info
    return "保密" if self.sex==SEX[:secret]
    return "男" if self.sex==SEX[:boy] 
    return "女" if self.sex==SEX[:girl]
    return ""   
  end

  #类型
  def type_str
	case self.type
    when 1 then '学生'
	when 2 then '老师'
	when 3 then '公司'
	else

	end
  end

  #权限说明
  def role_str
	case self.role_id
	when 1 then '普通用户'
	when 2 then '编辑'
	when 7 then '管理员'
	when 8 then '系统管理员'
    end
  end

  #取头像id
  def avatar_id(t='s')
    self.img['avatar'][t] || ''
  end

  #给头像赋值s
  def avatar_s=(id)
    self.img['avatar']['s'] = id
  end

  #给头像赋值m
  def avatar_m=(id)
    self.img['avatar']['m'] = id
  end

  #给头像赋值b
  def avatar_b=(id)
    self.img['avatar']['b'] = id
  end

private

  #创建用户登录标识
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  
end
