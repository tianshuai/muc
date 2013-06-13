#source 'https://rubygems.org'
source 'http://ruby.taobao.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'

gem "mongoid" ,	'~> 3.1.4'
gem "bson_ext"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.2.3'
end

gem 'execjs'  
gem 'therubyracer'

gem 'jquery-rails', '2.0.2'

#gem 'mongoid_auto_increment_id', "0.6.0"

gem 'bootstrap-sass', '2.0.4'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

#可以指定module为id自增
gem 'mongoid_auto_increment'

#分页
gem 'will_paginate', '3.0.3'
#分页样式
gem 'bootstrap-will_paginate', '0.0.6'
gem 'will_paginate_mongoid'

#mongoid自动生成日期
#gem 'mongoid_timestamp_define',:git => "git@github.com:helloqidi/mongoid_timestamp_define14.git"
#gem 'mongoid_timestamp_define',:git => "https://github.com/helloqidi/mongoid_timestamp_define14.git"
#

#上传大文件（只支持>mongoid3.0）
gem 'mongoid-grid_fs', "~> 1.8.0"
gem 'mime-types', '~> 1.19'

#图片读取存储
gem 'mini_magick'

#禁用烦人的 assets 请求日志
group :development do
  gem 'quiet_assets', git: 'git@github.com:AgilionApps/quiet_assets.git', tag: 'v0.1.0'
end

gem 'thin'

