class Post
  include Mongoid::Document
  include Mongoid::Timestamps


  field :content, type: String
  field :user_id, type: Integer
  field :type, type: Integer
  field :state, type: Integer
end
