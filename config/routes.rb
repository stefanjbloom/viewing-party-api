Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index]
      resources :sessions, only: :create
      resources :movies, only: [:index, :show]
      resources :viewing_parties, only: :create do
        post 'invite', to: 'viewing_party_invitations#create'
      end
      resources :viewing_party_invitations, only: :create
    end
  end
end

# Add Another User to Existing Viewing Party
# This endpoint should:

# require a valid API key for a given user in order to succeed
# not make any updates to the viewing party resource, but instead just add more users to the party. 
# Consider: what is the most RESTful path and controller organization for this case?
# Pass a valid viewing party ID in the path of the request
# POST("api/v1/viewing_parties/:id/invite")
# Note: You can either pass the API key in the request (shown here) or as a query parameter.
# Example Request

# {
#   "api_key": "e1An2gAidDbWtJuhbHFKryjU", // must be valid API key for host
#   "invitees_user_id": 14 // must be valid user ID in the system
# }