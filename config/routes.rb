# encoding: utf-8
Muc::Application.routes.draw do

  root to: 'home#index'

  #后台路由设置
  namespace :admin do |admin|
    #首页
    resources :home do
      match '/',  to: 'home#index'
    end

    #用户
    resources :users do
	  collection do
		post :ajax_set_state
		post :ajax_set_role
	  end
    end

    #新闻
    resources :posts do
	  collection do
		post :ajax_set_state
		post :destroy_more
		post :ajax_set_publish
		post :ajax_set_stick
	  end
    end

    #作品
    resources :arts do
	  collection do
		post :ajax_set_state
		post :destroy_more
		post :ajax_set_publish
		post :ajax_set_stick
	  end
    end

    #书籍
    resources :books do
	  collection do
		post :ajax_set_state
		post :destroy_more
		post :ajax_set_publish
		post :ajax_set_stick
	  end
    end

    #栏目
    resources :blocks do
	  collection do
		post :ajax_set_state
		post :destroy_more
		post :ajax_set_stick
	  end
    end

    #栏目位
    resources :block_spaces do
	  collection do
		post :ajax_set_state
		post :destroy_more
	  end
    end

    #分类
    resources :categories do
	  collection do
		post :ajax_set_state
		post :destroy_more
        get :news
        get :arts
        get :books
	  end
    end

    #静态页
    resources :statics do
	  collection do
		post :ajax_set_state
		post :destroy_more
		post :ajax_set_publish
		post :ajax_set_stick
        get :introduce
        get :enrollment
        get :student_serve
		get :ajax_change_type
        get :teach
	  end
    end

    #静态页分页
    resources :positions do
	  collection do
		post :ajax_set_state
		post :destroy_more
	  end
    end

  end
  #后台路由END


  match 'about',       to: 'home#about'
  match 'help',        to: 'home#help'
  match 'contact',     to: 'home#contact'

  #学院新闻
  get 'posts',					    to: 'posts#index' 
  get 'posts/:mark',			    to: 'posts#list'
  get 'post/:mark/:id',	            to: 'posts#show'
  delete 'post/del_post',			to: 'posts#ajax_del_post'
  post 'post/set_post_stick',		to: 'posts#set_post_stick'

  #学院概述
  get 'introduces',					to: 'introduces#index',		  as: 'introduces'
  get 'introduce/:mark',			to: 'introduces#show'

  #艺术教学
  get 'teaches',					to: 'teaches#index',		  as: 'teaches'
  get 'teach/new_art',				to: 'teaches#new_art'
  post 'teach/create_art',			to: 'teaches#create_art'
  get 'teach/edit_art',				to: 'teaches#edit_art'
  put 'teach/update_art',			to: 'teaches#update_art'
  get 'teache/ajax_load_img',       to: 'teaches#ajax_load_img'
  get 'teaches/:mark',				to: 'teaches#show'
  get 'art/:mark/:id',				to: 'teaches#art'
  delete 'teach/del_art',			to: 'teaches#ajax_del_art'
  post 'teach/set_art_stick',		to: 'teaches#set_art_stick'


  get 'teach/arts',                 to: 'teaches#arts'

  #学院丛书
  get 'books',                      to: 'books#index',            as: 'books'
  get 'books/:mark',                to: 'books#list'
  get 'book/:mark/:id',	            to: 'books#show'

  #招生详情
  get 'enrollments',				to: 'enrollments#index',		  as: 'enrollments'
  get 'enrollment/:mark',			to: 'enrollments#show'
  
  #学生工作
  get 'student_servies',			to: 'student_servies#index',	  as: 'student_servies'
  get 'student_serve/:mark',		to: 'student_servies#show'

  #学生工作
  get 'projects',				    to: 'projects#index',	  as: 'projects'
  get 'project/:mark',			    to: 'projects#show'

  #用户路由
  resources :users,			only: [:index, :new, :create, :show] 

  #用户注册登录
  match 'signup',					to: 'users#new'
  match 'login',					to: 'users#login'
  match 'user/edit_info',			to: 'users#edit_info'
  match 'user/update_info',			to: 'users#update_info'

  #个人资料设置
  match 'user/edit_pwd',			to: 'users#edit_pwd'
  match 'user/update_pwd',			to: 'users#update_pwd'
  match 'user/ajax_avatar_form',	to: 'users#ajax_avatar_form'


  #头像设置
  match 'user/edit_avatar',			to: 'users#edit_avatar'


  resources :sessions, only: [:new, :create, :destroy]
  match 'signin', to: 'sessions#new'
  match 'signout', to: 'sessions#destroy', via: :delete

  #上传路径
  match 'upload/editor'  => 'upload#editor'
  match 'upload/art_upload' => 'upload#art_upload'
  match 'upload/avatar_upload' => 'upload#avatar_upload'
  get 'upload/thumb_avatar_upload' => 'upload#thumb_avatar_upload'

  #附件处理
  get "asset/*path" => "assets#serve"
  delete "asset/destroy" => "assets#destroy"
  post "asset/ajax_save_desc" => "assets#ajax_save_desc"


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
