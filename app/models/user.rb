# encoding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword



  ##关系
  #内嵌表：用户详细信息
  embeds_one :profile
  has_many :posts




  before_save { |user| user.email = email.downcase }

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
  #审核
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

  #头像
  field :avatar,                type: Integer,  default: 0


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




  ##过滤
  #
  #学生
  scope :students,              where(type: TYPE[:student])


  ##验证
  validates :name,                        presence: true, length: { maximum: 6, maximum: 12 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,                       presence: true,
                                          format: { with: VALID_EMAIL_REGEX },
                                          uniqueness: { case_sensitive: false }

  validates :password_confirmation, presence: true
  validates :password, presence: true, length: { minimum: 6,maximum: 18 }


  ##
  #方法

  #性别信息
  def sex_info
    return "保密" if self.sex==SEX[:secret]
    return "男" if self.sex==SEX[:boy] 
    return "女" if self.sex==SEX[:girl]
    return ""   
  end


  
end
