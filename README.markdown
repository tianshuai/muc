## 基本信息
  * auther_by: tianshuai

  * Ruby 1.9.3+, Rails 3.2.13
  * 数据库mongodb 2.02
  * mongoid 3.1.4


##启动前准备工作
　*初次使用可以导入数据库模版，包括已经创建好的分类和栏目位信息，模版位于db目录下……
　*如发布到生产环境需要压缩js、css、img文件，命令：rake assets:precompile,  反之，清理压缩后的命令:rake assets:clean


 *如发布生产环境，静态文件由前端服务器处理，需要更改/config/environments/production.rb :   config.serve_static_assets = false


##启动
 *rails s　

