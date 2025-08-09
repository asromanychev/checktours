Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "/health", to: "health#index"

  # Mount Sidekiq Web UI only in development
  begin
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq" if Rails.env.development?
  rescue LoadError
    # sidekiq/web not available until bundle install
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
