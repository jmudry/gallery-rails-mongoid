GalleryRails::Application.routes.draw do

  resources :photos

  resources :albums do
    resources :photos,  :only => []   do
      match 'get/:which' => "albums#get_photo", :on => :member, :as => "get"
    end
  end

  devise_for :users ,:path => "" ,:path_names => {:sign_in => 'login', :sign_up => "register",:sign_out => 'logout'},
             :controllers => { :confirmations => "users/confirmations", :omniauth_callbacks => "users/omniauth_callbacks"} do
    get '/login' => 'devise/sessions#new'
    post '/login' => 'devise/sessions#create'
    get '/logout' => 'devise/sessions#destroy'

    get '/register' => 'devise/registrations#new'
    post '/register' => 'devise/registrations#create'
  end

  get '/' => "home#root_page"
  root :to => "home#root_page"

end
