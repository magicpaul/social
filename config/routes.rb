Social::Application.routes.draw do
  resources :quizzes do
    member do
      post 'start'
      get 'question'
      post 'question'
      post 'answer'
      get 'end'
      post 'share'
    end
  end
  resources :quiz_results
  resources :activities, only: [:index]
  resources :activities do
    member do
      post 'read'
      post 'all_read'
    end
  end
  get "profiles/show"
  as :user do
    get '/register', to: 'devise/registrations#new', as: :register
    get '/sign_in', to: 'devise/sessions#new', as: :sign_in
    get '/sign_out', to: 'devise/sessions#destroy', as: :sign_out
  end

  devise_for :users, skip: [:sessions]

  as :user do
    get '/sign_in' => 'devise/sessions#new', as: :new_user_session
    post '/sign_in' => 'devise/sessions#create', as: :user_session
    delete '/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :user_friendships do
    member do
      put :accept
      put :block
    end
  end
  resources :statuses do
    member do
       post 'like'
       post 'unlike'
    end
  end
  resources :statuses, path: 'updates'
  resources :statuses, path_names: { new: "create" }
  get 'feed', to: "statuses#index", as: :feed

  authenticated :user do
    root :to => "statuses#index"
  end
  unauthenticated :user do
    devise_scope :user do
      get "/" => "devise/sessions#new"
    end
  end

  get '/:id', to: 'profiles#show', as: 'profile'

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
