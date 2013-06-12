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

  def css_on?(css)
    "on" if css
  end

  #自动跳转(可直接在action中调用此方法)
  def auto_redirect(arg={})
     sec = arg[:sec] || 3
     url = arg[:url] || '/'
     msg = arg[:msg] || ''
     msg += " Redirect to '#{url}' after #{sec} sec"
     eval("render :text=>\"<meta http-equiv='refresh' content='#{sec}; url=#{url}'>#{msg}\"")
  end

  #创建多级目录
  def mkdirs(path)
    if(!File.directory?(path))
        if(!mkdirs(File.dirname(path)))
            return false;
        end
        Dir.mkdir(path)
    end
    return true
  end

  # 网站时间显示格式
  # Time.now.to_i可转换时间为integer
  #
  def format_time(integer)
    Time.at(integer).strftime("%Y-%m-%d %H:%M:%S")
  end


	#大图沦换排序
	def load_block_order(mark,limit=8)
	  block_space = BlockSpace.find_by(mark: mark)
	  if block_space.present?
		blocks = block_space.blocks.published.order_b.paginate(page: 1, per_page: limit)
	  else
		blocks = []
	  end
	end

	#加载静态页
	def load_page(position_tag,limit=20)
	  page_position = PagePosition.where(:position=>position_tag,:state=>1).first
	  if page_position.present?
		ads = page_position.info_pages.published.order_b.page(1).per(limit)
	  else
		ads = []
	  end
	end

	#加载区块儿内容
	def free_block(tag_id)
	  block = FreeBlock.find(tag_id)
	  return block.content if block.present?
	  return ''
	end

end
