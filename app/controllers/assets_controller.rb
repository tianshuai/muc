# encoding: utf-8
class AssetsController < ApplicationController

   def serve
     gridfs_path = env["PATH_INFO"].gsub("/asset/", "")
     begin
       gridfs_file = asset_obj(gridfs_path)
       if gridfs_file.present?
         self.response_body = gridfs_file.data
         self.content_type = gridfs_file.content_type
       else
         self.status = :file_not_found
         self.content_type = 'text/plain'
         self.response_body = 'file_not_found'
       end
     rescue
       self.status = :file_not_found
       self.content_type = 'text/plain'
       self.response_body = 'file_not_found'
     end
   end
end
