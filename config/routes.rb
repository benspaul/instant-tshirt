Instantt::Application.routes.draw do
  root :to => 'tshirts#index'
  resources :tshirts
end
