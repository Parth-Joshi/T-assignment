Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      post 'create_time_event' => 'events#create_time_event'
      post 'follow_unfollow_event' => 'events#follow_unfollow_event'
      get 'get_sleep_records_of_followers' => 'events#sleep_records_of_followers'
    end
  end
end
