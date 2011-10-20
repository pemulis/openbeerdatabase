OpenBeerDatabase::Application.routes.draw do
  constraints subdomain: "api" do
    namespace :v1, module: "Api::V1" do
      resources :beers,     only: [:index, :show, :create, :destroy]
      resources :breweries, only: [:index, :show, :create, :destroy]
    end
  end

  constraints subdomain: "www" do
    match "/*path" => redirect { |_, request| "http://#{request.host.sub("www.", "")}#{request.path}" }

    root to: redirect { |_, request| "http://#{request.host.sub("www.", "")}" }
  end

  constraints(lambda { |request| request.subdomain.blank? }) do
    resources :documentation, only: [:show]
    resource  :session,       only: [:new, :create]
    resources :users,         only: [:show, :new, :create]

    root to: "Documentation#show", id: "overview"
  end
end
