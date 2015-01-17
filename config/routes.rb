Rails.application.routes.draw do
  devise_for :users
  resources :quotes do
  	member do
  		put "like", to: "quotes#upvote"
  		put "dislike", to: "quotes#downvote"
  	end
  end



  root to: 'quotes#index'
end
