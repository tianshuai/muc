# encoding: utf-8
class Profile
  include Mongoid::Document
  
  ##关系
  embedded_in :user

  ##常量


  ##属性
  field :realname,    :type=>String

  field :id_card,        :type=>String

  field :im_qq,       :type=>String
  field :im_msn,      :type=>String

  #兴趣爱好
  field :interest,    :type=>String
  #个人介绍 |品牌介绍
  field :summary,     :type=>String
  #存储外部博客
  #sina,tencent,douban,renren,web,blog
  field :url,         :type=>Hash,:default=>{"sina"=>"","tencent"=>"","douban"=>"","renren"=>"","web"=>"","blog"=>""}
  field :bank_card,  :type=>Integer





end
