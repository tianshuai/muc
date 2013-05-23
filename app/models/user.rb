class User
  include Mongoid::Document
  #include Mongoid::Timestamps

  ##关系
  has_many :posts

  ##属性
  field :name, type: String
  field :email, type: String
end
