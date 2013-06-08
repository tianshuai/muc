# encoding: utf-8
##附件表
class Asset
  include Mongoid::Document
  include Mongoid::Timestamps


  #关联
  belongs_to :art
  belongs_to :post, 		class_name: "Item",			foreign_key: "relate_id"

  ##常量
  #附件类型
  ASSET_TYPE = {
	#作品
  	art: 1,
	#新闻图片
	post: 5,
	#编辑器图片
	editer: 10
  }
  
  #处理状态
  STATE={
	no: 0,
	ok: 1
  }


  ##属性
  #关联id，可以定期执行任务，把关联id为空的垃圾删除！！！
  field :relate_id,          		type: Integer

  field :original_url,      		type: String
  field :original_file,     		type: String
  field :filename,          		type: String

  #类型（备用）
  field :type,						type: Integer,		default: 1
  #状态
  field :state,						type: Integer,		default: STATE[:ok]
  #附件类型
  field :asset_type,        		type: Integer,		default: ASSET_TYPE[:art]

  field :size,              		type: Integer,		default: 0

  #存储fs的id,字符串类型
  field :thumb_small,       		type: String
  field :thumb_middle,      		type: String
  field :thumb_big,         		type: String

  field :width,             		type: Integer,		default: 0
  field :height,            		type: Integer,		default: 0
  field :thumb_big_height
  field :thumb_big_width
  field :thumb_middle_height
  field :thumb_middle_width
  field :thumb_small_height
  field :thumb_small_width

  #用于存储图片类型,默认是jpg
  field :img_type,					type: String,		default: "jpg"
  #图片描述信息
  field :desc,   					type: String

  #排序
  field :order,						type: Integer,		default: 0

  #索引
  #关联id
  index({ related_id: 1 }, { background: true })

  #过滤
  scope :recent,    		desc(:created_at)
  scope :order_b,			asc(:order)
 


  #同时删除mongodb中存储的图片
  before_destroy :delete_for_fsfile

  #删除asset,同时删除fs文件
  def destroy_with_fs
    if self.destroy
      delete_for_fsfile
      return true
    else
      return false
    end
  end


  private
  def delete_for_fsfile
    a = [self.thumb_small,self.thumb_middle,self.thumb_big,self.original_file]
    a.each do |fsid|
      Mongoid::GridFS.delete(fsid) if fsid.present?
    end
  end


end