Rottenpotatoes::Application.routes.draw do
  resources :movies do
  	get "similar" => "movies#similar", as: :similar
  end
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')

  # get "similar/:id" => "movies#similar", as: :similar
end
