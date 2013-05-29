# encoding: utf-8
class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  ##关系
  belongs_to :user


  ##属性
  field :content, type: String
  field :user_id, type: Integer
  field :type, type: Integer
  field :state, type: Integer
end
