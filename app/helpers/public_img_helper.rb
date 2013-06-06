# encoding: utf-8
module PublicImgHelper

  #图片对象
  def asset_obj(asset_id)
	Mongoid::GridFS.get(asset_id)
  end

  #默认头像地址
  def default_avatar(t='s')
	case t
    when 's' then img_url = 'avatar_small.gif'
    when 'm' then img_url = 'avatar_medium.gif'
    when 'b' then img_url = 'avatar_big.gif'
    else
	  img_url = 'avatar_small.gif'
	end
  end

  #取头像链接(user参数为用户对象；t参数为大中小，分为用'b','m','s'表示，最后为可选参数，如：:alt=>'',:width=>'',:class=>''等等)
  def user_avatar_tag(user,t,options={})
    if user.present? and user.avatar_id(t).present? and asset_obj(user.avatar_id(t)).present?
	  url = asset_path(user.avatar_id(t))
	  img = image_tag(url,options)
	else
	  img = image_tag(default_avatar(t),options)
    end
  end

end
