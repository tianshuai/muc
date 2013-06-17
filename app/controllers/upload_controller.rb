# encoding: utf-8
class UploadController < ApplicationController

  def editor
  	file = params[:imgFile]
	file_temp = file.tempfile
	file_format = file.content_type
	file_name = file.original_filename

	#上传
	result = ImageUnit::Upload.save_asset(file_temp,file_format.split('/').last)
	if result[:result]
	  item_id = params[:item_id] || ''
	  asset = Asset.new({
		relateable_id: item_id.to_i, 
		relateable_type: params[:type],
		original_file: result[:file_o_id],
		thumb_small: result[:file_s_id],
		filename: file_name,
		size: result[:size],
		format_type: file_format
	  })
	  if asset.save
		results = {
			error: 0,
			url: asset_path(asset.original_file),
			asset_id: asset.id
		}
	  else
		results = {
			error: 1,
			message: '上传失败!'
		}
	  end

	else
	  results = {
	    error: 1,
		message: result[:message]
	  }
	end

	render json: results.to_json
  end

  def art_upload
    file = params[:Filedata]
	file_temp = file.tempfile
	file_format = file.content_type
	file_name = file.original_filename

	#上传
	result = ImageUnit::Upload.save_asset(file_temp,file_format.split('/').last)

	if result[:result]
	  item_id = params[:item_id] || ''
	  asset = Asset.new({
		relateable_id: item_id.to_i, 
		relateable_type: params[:type],
		original_file: result[:file_o_id],
		thumb_small: result[:file_s_id],
		filename: file_name,
		size: result[:size],
		format_type: file_format
	  })
	  if asset.save
        p 'a11111111111111111'
        p asset
		results = {
			error: 0,
			url: asset_path(asset.original_file),
			asset_id: asset.id
		}
	  else
        p '2222222222222'
		results = {
			error: 1,
			message: '上传失败!'
		}
	  end

	else
      p '333333333333'
	  results = {
	    error: 1,
		message: result[:message]
	  }
	end

	render json: results.to_json



  end

end
