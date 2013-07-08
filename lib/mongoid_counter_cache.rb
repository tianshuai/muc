module Mongoid
  module CounterCache
    extend ActiveSupport::Concern

	included do
	  self::COUNTER_CACHE=[]
	end

	module InstanceMethods
	  #对counter_cache记录的表和字段进行递减操作,减操作不能出现负数
	  #可用于非物理删除的情况
	  def counter_cache_delete
		self.class::COUNTER_CACHE.each do |group|
		  name=group[:name]
		  counter_field=group[:field]
		  if_judge_m=group[:if]
		  if_destroy=group[:destroy]
			
		  next if if_destroy==false
		  #判断是否执行
          if (if_judge_m==nil) || (if_judge_m && self.send(if_judge_m))
			relation = self.send(name)
			if relation
			  if relation.class.fields.keys.include?(counter_field)
				relation.inc(counter_field.to_s, -1) unless relation.send(counter_field.to_s).to_i<=0
			  else
				#针对虚拟属性
				hash={counter_field.to_s=>relation.send(counter_field)-1}
				relation.update_attributes(hash) unless relation.send(counter_field.to_s).to_i<=0
			  end
			end
		  end#if
		end#each
	  end#counter_cache_delete

	  #对counter_cache记录的表和字段进行递增操作
	  #可用于撤销非物理删除的情况
	  def re_counter_cache_delete
		self.class::COUNTER_CACHE.each do |group|
		  name=group[:name]
		  counter_field=group[:field]
		  if_judge_m=group[:if]
		  if_destroy=group[:destroy]

		  #判断是否执行
          if (if_judge_m==nil) || (if_judge_m && self.send(if_judge_m))
			relation = self.send(name)
			if relation
			  if relation.class.fields.keys.include?(counter_field)
				relation.inc(counter_field.to_s, 1)
			  else
				#针对虚拟属性
				hash={counter_field.to_s=>relation.send(counter_field)+1}
				relation.update_attributes(hash)
			  end
			end
		  end#if
		end#each
	  end#re_counter_cache_delete    
	end

    module ClassMethods
      def counter_cache(options)
        name = options[:name]
        counter_field = options[:field]
        #获得if指定的方法 :if=>:stuff?
        if_judge_m=options[:if]
        #是否执行删除方法 :destroy=>false
        if_destroy=options[:destroy]

		self::COUNTER_CACHE<<{:name=>name,:field=>counter_field,:if=>if_judge_m,:destroy=>if_destroy}

        after_create do |document|
          #判断是否执行
          if (if_judge_m==nil) || (if_judge_m && document.send(if_judge_m))
            relation = document.send(name)
            if relation
              if relation.class.fields.keys.include?(counter_field)
                relation.inc(counter_field.to_s, 1)
              else
                #针对虚拟属性
                hash={counter_field.to_s=>relation.send(counter_field)+1}
                relation.update_attributes(hash)
              end
            end
          end
        end

		#减操作不能出现负数
        after_destroy do |document|
          return if if_destroy==false
          #判断是否执行
          if (if_judge_m==nil) || (if_judge_m && document.send(if_judge_m))
            relation = document.send(name)
            if relation
              if relation.class.fields.keys.include?(counter_field)
                relation.inc(counter_field.to_s, -1) unless relation.send(counter_field.to_s).to_i<=0
              else
                hash={counter_field.to_s=>relation.send(counter_field)-1}
                relation.update_attributes(hash) unless relation.send(counter_field.to_s).to_i<=0
              end
            end
          end
        end

      end
    end

  end
end
