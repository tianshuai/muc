# encoding: utf-8
class UploadController < ApplicationController

  def editor
  	file = params[:imgFile]
	file_temp = file.tempfile
	file_name = file.original_filename

	#上传
	result = ImageUnit::Upload.save_asset(file_temp,2)
	if result[:result]
	  item_id = (params[:item_id] || 0).to_i
      result[:file_name] = file_name
      result[:relateable_id] = item_id
      result[:relateable_type] = params[:type]
      hash = collect_asset(result)
	  asset = Asset.new(hash)
	  if asset.save
		results = {
			error: 0,
            #编辑器存生成的大图
			url: asset_path(asset.thumb_big),
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
	  item_id = (params[:item_id] || 0).to_i
      result[:relateable_id] = item_id
      result[:relateable_type] = params[:type]
      hash = collect_asset(result)
	  asset = Asset.new(hash)
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
