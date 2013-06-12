# encoding: utf-8
Muc::Application.routes.draw do

  root to: 'home#index'

  #后台路由设置
  namespace :admin do |admin|
    resources :users do
	  collection do
		post :ajax_set_state
		post :ajax_set_role
	  end
    end

    resources :home do
      match '/',  to: 'home#index'
    end

    resources :posts do
	  collection do
		post :ajax_set_state
		post :destroy_more
		post :ajax_set_publish
		post :ajax_set_stick
	  end
    end

    resources :blocks do
	  collection do
		post :ajax_set_state
		post :destroy_more
		post :ajax_set_stick
	  end
    end

    resources :block_spaces do
	  collection do
		post :ajax_set_state
		post :destroy_more
	  end
    end

    resources :arts do
      #match '/',  to: 'home#index'
    end

    resources :categories do
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
  resources :posts,				except: :show
  get 'posts',					to: 'posts#index' 
  get 'posts/:mark',			to: 'posts#list'
  get 'post/news/:mark/:id',	to: 'posts#show'

  #学院概述
  get 'introduce',				to: 'introduces#index',		as: 'introduces'
  get 'introduce/faculties',	to: 'introduces#faculties'
  get 'introduce/leader',		to: 'introduces#leader'

  #艺术教学
  get 'teach/index',			to: 'teaches#index',		as: 'teaches'
  get 'teach/teacher',			to: 'teaches#teacher'


  #用户路由
  resources :users,			only: [:index, :new, :create, :show] 

  match '/signup',            to: 'users#new'
  match '/login',             to: 'users#login'
  match '/user/edit_info',	  to: 'users#edit_info'
  match '/user/update_info',  to: 'users#update_info'

  match '/user/edit_pwd',     to: 'users#edit_pwd'
  match '/user/update_pwd',   to: 'users#update_pwd'


  resources :sessions, only: [:new, :create, :destroy]
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  #图片路径
  match "/asset/*path" => "assets#serve"


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
