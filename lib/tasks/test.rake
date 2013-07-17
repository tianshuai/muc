# encoding: utf-8

namespace :test do
  desc 'china_city is drop_tag'
  task :test => :environment do
	users = User.all.size
    puts "success!!#{users}"
  end
end
