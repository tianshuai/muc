class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id,   type: Integer
  field :name, type: String
  field :email, type: String
end
