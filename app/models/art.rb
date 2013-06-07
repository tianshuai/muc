# encoding: utf-8
##作品表
class Art
  include Mongoid::Document
  include Mongoid::Timestamps
  
  ##关系
  belongs_to :user

  ##常量
  #状态
  STATE={
  	going: 0,
    #草稿
    failure: 1,
    #通过
    pass: 2
  }
  
  STICK={
    #未推荐
    no: 0,
    #推荐
    yes: 1
  }

  #是否发布
  PUBLISH={
	#未发布
	no: 0,
	#已发布
	yes: 1
  }

  ##属性
  field :user_id,						type: Integer

  #field :category_id,					type: Integer

  #图片id
  field :asset_id,						type: Integer

  #附件的数量
  field :asset_count,   				type: Integer,  default: 1
  
  #状态
  field :state,							type: Integer,	default: STATE[:pass]

  #是否发布
  field :publish,						type: Integer,	default: PUBLISH[:yes]

  field :title,  						type: String
  field :content,						type: String

  #评论数量
  #field :comment_cnt,					type: Integer,  default: 0

  #查看数量
  field :view_count,    				type: Integer,	 default: 0

  #是否被管理员推荐  1:是；0：否
  field :stick,      					type: Integer,	 default: STICK[:no]

  #过滤
  #最近的
  scope :recent,			  desc(:created_at) 
  #已发布的
  scope :published,           where(publish: PUBLISH[:yes])
  #正常显示的
  scope :pass,                where(state: STATE[:ok])

  ##索引
  index({ title: 1 }, { background: true })
  index({ created_at: -1 }, { background: true })



end
