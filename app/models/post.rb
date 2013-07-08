# encoding: utf-8
class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::CounterCache

  #ＩＤ自增
  auto_increment :id, seed: 1

  ##关系
  has_many :assets,         dependent: :destroy,  as: :relateable
  belongs_to :user
  belongs_to :category

  #更新user表中对应的数量
  counter_cache name: 'user', field: 'arts_count',	if: :art?
  counter_cache name: 'user', field: 'news_count',	if: :news?

  ##验证
  validates_presence_of :title
  validates :title,                               length: { minimum: 2, maximum: 50 }

  validates :content,                             length: { maximum: 50000 }
  validates_presence_of :user_id,				  message: '请选择创建人'
  validates_presence_of :category_id,			  message: '请选择分类'

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
  TYPE={
    #新闻
    news: 1,
    #作品
    art: 2,
    #学院丛书
    book: 3,
	# 师资
	teacher: 4,
	#通用
	common: 10
  }

  #推荐
  STICK = {
	#未推荐
	no: 0,
	yes: 1
	}


  ##属性
  field :title,               type: String
  field :content,             type: String
  field :user_id,             type: Integer
  #类型
  field :type,                type: Integer,  default: TYPE[:news]
  #封面图
  field :asset_id,            type: Integer,  default: 0
  #分类
  field :category_id,         type: Integer
  #状态
  field :state,               type: Integer,  default: STATE[:ok]
  #是否发布
  field :publish,             type: Integer,  default: PUBLISH[:yes]

  #查看数量
  field :view_count,    	  type: Integer,  default: 0
  #推荐
  field :stick,				  type: Integer,  default: STICK[:no]

  #排序
  field :order,               type: Integer,  default: 0

  ##索引
  index({ title: 1 }, { background: true })
  index({ created_at: 1 }, { background: true })
  index({ view_count: 1 }, { background: true })
  index({ category_id: 1 }, { background: true })
  index({ type: 1 }, { background: true })

  ##
  #过滤
  
  #最新的
  scope :recent,			-> { desc(:_id) }
  #按自定义排序
  scope :order_b,           -> { desc(:order) }
  #已发布的
  scope :published,         -> { where(publish: PUBLISH[:yes]) }
  #未发布的
  scope :unpublished,       -> { where(publish: PUBLISH[:no]) }
  #正常显示的
  scope :normal,            -> { where(state: STATE[:ok]) }
  #禁用的
  scope :forbid,            -> { where(state: STATE[:no]) }
  #是新闻
  scope :news,              -> { where(type: TYPE[:news]) }
  #是丛书
  scope :books,             -> { where(type: TYPE[:book]) }
  #是作品
  scope :arts,              -> { where(type: TYPE[:art]) }
  #师资
  scope :teachers,			-> { where(type: TYPE[:teacher]) }
  #是 通用
  scope :commons,           -> { where(type: TYPE[:common]) }
  #推荐的
  scope :sticked,			-> { where(stick: STICK[:yes]) }


  #地址（不同分类下的内容走不同地址）
  def view_url()
	if self.category.present?
	  case type
	  when 1  then	sprintf(CONF['news_url'], self.category.mark, self.id)
	  when 2  then	sprintf(CONF['arts_url'], self.category.mark, self.id)
	  when 3  then	sprintf(CONF['books_url'], self.category.mark, self.id)
	  when 4  then	sprintf(CONF['teachers_url'], self.category.mark, self.id)
	  # 如果是通用，需要手动指定路径（以后需要改进）
	  when 10
		case self.category.mark
		# 学生工作
		when 'student_serve' then path = 'serve'
		else
		  path = 'common'
		end
		sprintf(CONF['commons_url'], path, self.category.mark, self.id)
	  end
	else
	  CONF['domain_base']
	end
  end

  # 是否发布
  def published?
	return false if self.publish == PUBLISH[:no]
	return true
  end

  #是否禁用
  def forbid?
	return true if self.state == STATE[:no]
	return false
  end

  #只取封面图，没有则为nil
  def cover
    return nil if self.asset_id == 0
    asset = Asset.find(self.asset_id)
    if asset.present?
      return asset 
    else
      return nil
    end
  end

  #如果有封面图，取之，没有取所有附件第一个
  def asset
    if self.asset_id == 0
      asset =  self.assets.first if self.assets.present?
    else
      asset = Asset.find(self.asset_id)
    end
    return  asset
  end

  #判断类型?(未应用)
  def is_type?(str)
	return true if self.type==TYPE[str.to_sym]
	return false
  end

  def art?
	return true if self.type==TYPE[:art]
	return false
  end

  def news?
	return true if self.type==TYPE[:news]
	return false
  end
  
end
