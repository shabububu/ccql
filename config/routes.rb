Rails.application.routes.draw do
  
  mount Blacklight::Engine => '/'
  
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, 
             skip: [:registrations],
             controllers: { 
               omniauth_callbacks: 'vdc/omniauth_callbacks',
               registrations:      'vdc/registrations' }

  # Update devise routes to only allow new/create/cancel 
  # for new user registrations. The other operations will only
  # be allowed by the admin for now
  as :user do
    get   '/users/sign_up', to: 'vdc/registrations#new', as: :new_user_registration
    post  '/user', to: 'vdc/registrations#create', as: :user_registration
    get   '/users/cancel', to: 'vdc/registrations#cancel', as: :cancel_user_registration
  end

  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Hyrax::Engine.routes.draw do  
  namespace :admin do
    namespace :vdc do
      post 'pending_registrations/approve_user'
      resources :pending_registrations, only: [:index]
      if Rails.env.development?
        resources :people
      else
        resources :people, except: [:index]  
      end
    end
    resources :users, only: [:edit, :update]
  end

  match "/download_cv/:id/", controller: "admin/users", action: "download_cv", via: :get
end
