# encoding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  auto_increment :id, seed: 1000
  attr_accessible :name, :email, :password, :password_confirmation

  ##关系
  #内嵌表：用户详细信息
  embeds_one :profile
  has_many :posts,            dependent: :destroy



  #注册时把邮箱转换为小写字符
  before_save { |user| user.email = email.downcase }

  #创建用户登录标识
  before_save :create_remember_token


  #密码自动加密
  has_secure_password


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

  #保护字段
  attr_protected :role_id

  ##属性
  field :name,                  type: String
  field :email,                 type: String

  #密码(加密)
  field :password_digest,       type: String

  #头像
  field :avatar,                type: String


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

  #是否初次登录、
  field :first_login,           type: Integer,  default: 0

  #记忆权标
  field :remember_token,        type: String


  ##索引
  index({ name: 1 }, { background: true })
  index({ email: 1 }, { unique: true, background: true })
  index({ remember_token: 1 }, { unique: true, background: true })
  index({ name: 1 }, { unique: true, background: true })


  ##过滤
  #
  #学生
  scope :students,              where(type: TYPE[:student])


  ##验证
  validates_presence_of :name,                    message: '不能为空'
  validates :name,                                length: { minimum: 4, maximum: 18, message: '长度大于4个字符且小于18个字符' }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_presence_of :email,                   message: '不能为空'
  validates :email,                               format: { with: VALID_EMAIL_REGEX,  message: '格式不正确' },
                                                  uniqueness: { case_sensitive: false, message: '已经存在!' }

  #validates_presence_of :password,                message: '不能为空'
  #validates :password,                            length: { minimum: 6,maximum: 18, message: '长度大于6个字符且小于18个字符' }
  #validates_presence_of :password_confirmation,   message: '不能为空'



  ##
  #方法

  #性别信息
  def sex_info
    return "保密" if self.sex==SEX[:secret]
    return "男" if self.sex==SEX[:boy] 
    return "女" if self.sex==SEX[:girl]
    return ""   
  end

private

  #创建用户登录标识
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  
end
