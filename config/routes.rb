Rails.application.routes.draw do
  devise_for :users
  resources :products, except: [:new, :edit]
  match 'products/:id/recover' => 'products#recover', via: [:put, :patch]
end
