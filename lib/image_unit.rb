# encoding: utf-8
module ImageUnit

  class Upload
  
    #保存图片
    #type::1,编辑器图片／２.作品图片；３.栏目块图片
    def self.save_asset(file,type,options={})

	  image_io= open(file)

      #用minimagick读取文件
      image_mini = MiniMagick::Image.read(image_io)

      result = {}
	  #判断格式/大小
	  set_format = CONF['verify_img_type']
      #整数转换为字节
      verify_size = (options[:size] || 2).to_i.megabytes
      size = result[:size] = image_mini[:size]
      format = result[:format] = image_mini[:format]
	  return { message: "只支持JPG、JPEG、PNG、GIF文件", result: false } unless set_format.include?(format)
	  return { message: "文件大小不要超过2Mb", result: false } unless verify_size > size


	  grid = Mongoid::GridFS
      #原图
	  grid_o  = grid.put(image_mini.path)
      result[:file_o_id]  = grid_o.id
      result[:file_o_width]  = image_mini[:width]
      result[:file_o_height]  = image_mini[:height]

      case type
      when 1 then resize = CONF['image_art_format']
      when 2 then resize = CONF['image_editor_format']
      else
        resize = CONF['image_art_format']
      end

      #大图
      #image_mini.resize "740x>!"
      resize_b = resize['b'] || 740
      image_mini.combine_options do |img|
        img.resize "#{resize_b}x>"
        img.quality "85"
      end
      grid_b = grid.put(image_mini.path)
      result[:file_b_id]  = grid_b.id
      result[:file_b_width]  = image_mini[:width]
      result[:file_b_height]  = image_mini[:height]

      #中图
      #image_mini.resize "100x85!"
      resize_m = resize['m'] || [170,120]
      if image_mini[:width]<=image_mini[:height]
        image_mini.combine_options do |img|
          img.resize "#{resize_m[0]}x"
          img.quality "100"
          img.gravity "center"
          img.crop  "#{resize_m[0]}x#{resize_m[1]}+0+0"
        end
      else
        image_mini.combine_options do |img|
          img.resize "x#{resize_m[1]}"
          img.quality "100"
          img.gravity "center"
          img.crop  "#{resize_m[0]}x#{resize_m[1]}+0+0"
        end		  
      end
      grid_m = grid.put(image_mini.path)
      result[:file_m_id]  = grid_m.id
      result[:file_m_width]  = image_mini[:width]
      result[:file_m_height]  = image_mini[:height]

      #小图
      # 生产小尺寸缩略图(先缩后裁形成方形图)
      resize_s = resize['s'] || [50,50]
      if image_mini[:width]<=image_mini[:height]
        image_mini.combine_options do |img|
          img.resize "#{resize_s[0]}x"
          img.quality "100"
          img.gravity "center"
          img.crop  "#{resize_s[0]}x#{resize_s[1]}+0+0"
        end
      else
        image_mini.combine_options do |img|
          img.resize "x#{resize_s[1]}"
          img.quality "100"
          img.gravity "center"
          img.crop  "#{resize_s[0]}x#{resize_s[1]}+0+0"
        end		  
      end

      grid_s = grid.put(image_mini.path)
      result[:file_s_id] = grid_s.id
      result[:file_s_width] = image_mini[:width]
      result[:file_s_height] = image_mini[:height]

      if grid_o.present? and grid_b.present? and grid_m.present? and grid_s.present?
        result[:result] = true
        return  result

      else
        return  { message: 'failr', reslut: false }
      end

    end

  end

end
