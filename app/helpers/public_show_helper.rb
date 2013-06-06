# encoding: utf-8
module PublicShowHelper

  #网站域名路径
  def domain_base
	CONF['domain_base']
  end

  #图片根路径
  def domain_image
	CONF['domain_image']
  end

  #图片地址
  def asset_path(asset_id)
	File.join(domain_image,asset_id)
  end

  ##
  # 定义某些元素的class是否是active  或　current
  def css_active?(css)
	"active" if css
  end

  def css_current?(css)
	"current" if css
  end

end
