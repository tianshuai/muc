# encoding: utf-8
class AssetsController < ApplicationController

   def serve
     gridfs_path = env["PATH_INFO"].gsub("/asset/", "")

     begin
       gridfs_file = Mongoid::GridFS.get(gridfs_path)

       self.response_body = gridfs_file.data

       self.content_type = gridfs_file.content_type

     rescue
       self.status = :file_not_found
       self.content_type = 'text/plain'
       self.response_body = ''
     end
   end
end
