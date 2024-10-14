require "rails_helper"

RSpec.describe "Viewing Parties Requests", type: :request do
  before(:each) do
    @host = User.create!(:name => "Stef", :username => "steffy", :password => "231", api_key: Rails.application.credentials.dig(:tmdb, :key))
    @invitee1 = User.create!(:name => "Tom", :username => "tom_tom", :password => "123")
    @invitee2 = User.create!(:name => "Jen", :username => "jen_jen", :password => "321")
  end

  describe "happy paths" do
    it "#create can create a viewing party with a host and invitees and return proper formatted response" do
      viewing_party_request = {
        name: "Test Party",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        api_key: @host.api_key,
        invitees: [{id: @invitee1.id, name: @invitee1.name, username: @invitee1.username},
                  {id: @invitee2.id, name: @invitee2.name, username: @invitee2.username}]
      }

      post "/api/v1/viewing_parties", params: viewing_party_request

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      party = json[:data]

      expect(party).to have_key(:id)
      expect(party).to have_key(:type)
      expect(party[:type]).to eq("viewing_party")
      expect(party).to have_key(:attributes)
      expect(party[:attributes][:name]).to eq("Test Party")
      expect(party[:attributes][:start_time]).to eq("2025-02-01T10:00:00.000Z")
      expect(party[:attributes][:end_time]).to eq("2025-02-01T14:30:00.000Z")
      expect(party[:attributes][:movie_id]).to eq(278)
      expect(party[:attributes][:movie_title]).to eq("The Shawshank Redemption")
      expect(party[:attributes][:invitees]).to eq([
        {id: @invitee1.id, name: @invitee1.name, username: @invitee1.username},
        {id: @invitee2.id, name: @invitee2.name, username: @invitee2.username}
      ])
    end
  end

  # describe "sad paths" do
  #   it "#create will render error if there is no host" do

  #   end

  #   it "#create will render error if api key is invalid" do

  #   end

  #   it "#create will render error if party duration is less than movie runtime" do

  #   end

  #   it "#create will render error if end time is before start time" do

  #   end

  #   it "#create will only render correct user ids if some user ids are invalid" do

  #   end
  # end
end
