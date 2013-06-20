# encoding: utf-8
class UploadController < ApplicationController

  def editor
  	file = params[:imgFile]
	file_temp = file.tempfile
	file_name = file.original_filename

	#上传
	result = ImageUnit::Upload.save_asset(file_temp,2)
	if result[:result]
	  item_id = params[:item_id] || ''
	  asset = Asset.new({
		relateable_id: item_id.to_i, 
		relateable_type: params[:type],
		original_file: result[:file_o_id],
        thumb_big: result[:file_b_id],
        thumb_middle: result[:file_m_id],
		thumb_small: result[:file_s_id],
		filename: file_name,
		size: result[:size],
		format_type: result[:format],
        width: result[:file_o_width],
        height: result[:file_o_height],
        thumb_big_height: result[:file_b_height],
        thumb_big_width: result[:file_b_width],
        thumb_middle_width: result[:file_m_width],
        thumb_middle_height: result[:file_m_height],
        thumb_small_width: result[:file_s_width],
        thumb_small_height: result[:file_s_height]
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
	file_name = file.original_filename

	#上传
	result = ImageUnit::Upload.save_asset(file_temp,1)

	if result[:result]
	  item_id = params[:item_id] || ''
	  asset = Asset.new({
		relateable_id: item_id.to_i, 
		relateable_type: params[:type],
		original_file: result[:file_o_id],
        thumb_big: result[:file_b_id],
        thumb_middle: result[:file_m_id],
		thumb_small: result[:file_s_id],
		filename: file_name,
		size: result[:size],
		format_type: result[:format],
        width: result[:file_o_width],
        height: result[:file_o_height],
        thumb_big_height: result[:file_b_height],
        thumb_big_width: result[:file_b_width],
        thumb_middle_width: result[:file_m_width],
        thumb_middle_height: result[:file_m_height],
        thumb_small_width: result[:file_s_width],
        thumb_small_height: result[:file_s_height]
        
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

end
