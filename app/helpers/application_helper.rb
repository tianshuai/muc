# encoding: utf-8
module ApplicationHelper

  #页面标题
  def page_title(title)
    base_title = "中央民族大学美术学院"
    if title.empty?
      base_title
    else
      "#{base_title} | #{title}"
    end
  end

  # sha1 加密
  def pwd_sha1(pass)
      Digest::SHA1.hexdigest(pass)
  end

  # md5 加密
  def pwd_md5(pass)
     Digest::MD5.hexdigest(pass)
  end

  # hash 加密
  def pwd_hash(pass)
    Digest::SHA256.hexdigest(pass)
  end


  # 随机产生字符串
  def random_string(len)
    randstring = ""
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a 
    1.upto(len) { |i| randstring << chars[rand(chars.size-1)] }
    return randstring
  end

end
