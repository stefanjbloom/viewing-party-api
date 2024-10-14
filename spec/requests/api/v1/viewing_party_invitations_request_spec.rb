require "rails_helper"

RSpec.describe "Viewing Party Invitations Requests", type: :request do
  before(:each) do
    @host = User.create!(:name => "Stef", :username => "steffy", :password => "231", api_key: Rails.application.credentials.dig(:tmdb, :key))
    @invitee1 = User.create!(:name => "Tom", :username => "tom_tom", :password => "123")
    @invitee2 = User.create!(:name => "Jen", :username => "jen_jen", :password => "321")
    @invitee3 = User.create!(:name => "Ruben", :username => "new_guy", :password => "000")
    @existing_viewing_party = ViewingParty.create!(
      name: "Test Party",
      start_time: "2025-02-01 10:00:00",
      end_time: "2025-02-01 14:30:00",
      movie_id: 278,
      movie_title: "The Shawshank Redemption",
      host: @host
    )
    ViewingPartyUser.create!(viewing_party: @existing_viewing_party, user: @host)
    ViewingPartyUser.create!(viewing_party: @existing_viewing_party, user: @invitee1)
    ViewingPartyUser.create!(viewing_party: @existing_viewing_party, user: @invitee2)
  end

  describe "happy paths" do
    it '#create will add a user to an existing viewing party' do
      post "/api/v1/viewing_parties/#{@existing_viewing_party.id}/invite", params: {
        api_key: @host.api_key,
        invitees_user_id: @invitee3.id
      }

      json = JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:invitees]

      expect(response).to have_http_status(:ok)
      expect(json).to include({id: @invitee1.id, name: @invitee1.name, username: @invitee1.username},
        {id: @invitee2.id, name: @invitee2.name, username: @invitee2.username},
        {id: @invitee3.id, name: @invitee3.name, username: @invitee3.username})
    end
  end
end
