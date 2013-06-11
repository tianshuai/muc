# encoding: utf-8
module ImageUnit


  class Upload
  


    #保存图片
    def self.save_asset(file,format,options={})
	  image_io= open(file)

	  image_io_size = image_io.size
	  #判断格式/大小
	  set_format = CONF['verify_img_type']

	  set_size=2000000
	  return { message: "只支持JPG、JPEG、PNG文件", result: false } unless set_format.include?(format.downcase)
	  return { message: "文件大小不要超过2Mb", result: false } unless set_size>image_io_size

      #用minimagick读取文件
      image_mini = MiniMagick::Image.read(image_io)

	  grid = Mongoid::GridFS
	  #image_mini = MiniMagick::Image.read(image_io)
	  grid_o  = grid.put(image_mini.path)

        #image_mini.resize "50x50!"
        image_mini.combine_options do |img|
          #img.resize "50x50!"
          #img.quality 100
          img.resize "100x"
          img.quality "85"
          img.gravity "center"
          img.crop  "100x60+0+0"
        end

		grid_s = grid.put(image_mini.path)

	    if grid_o.present? and grid_s.present?
	      return  { message: 'success' ,file_o_id: grid_o.id, file_s_id: grid_s.id, size: image_io_size, result: true } 
	    else
	      return  { message: 'failr', reslut: false }
	    end

    end

  end

end
