require 'rails_helper'

RSpec.describe "Movies API", type: :request do
  describe "happy paths" do
    it "#find calls MovieGateway#show_movie_details to return formatted details" do
      api_key = Rails.application.credentials.dig(:tmdb, :key)
      json_response = File.read("spec/fixtures/tmdb_find_query.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/157336?api_key=#{api_key}&append_to_response=reviews,credits").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v2.10.1'
          }).
        to_return(status: 200, body: json_response, headers: {})

        movie = MovieGateway.show_movie_details(157336)

        expect(movie).to be_a(Hash)
        expect(movie[:data]).to be_a(Hash)
        expect(movie[:data][:id]).to eq(157336)
        expect(movie[:data][:type]).to eq("movie")
        expect(movie[:data][:attributes][:title]).to eq("Interstellar")
        expect(movie[:data][:attributes][:release_year]).to eq(2014)
        expect(movie[:data][:attributes][:vote_average]).to eq(8.4)
        expect(movie[:data][:attributes][:runtime]).to eq("2 hours, 49 minutes")
        expect(movie[:data][:attributes][:genres]).to eq(["Adventure", "Drama", "Science Fiction"])
        expect(movie[:data][:attributes][:summary]).to eq("The adventures of a group of explorers...")
        expect(movie[:data][:attributes][:cast].count).to eq(10)
        expect(movie[:data][:attributes][:total_reviews]).to eq(16)
        expect(movie[:data][:attributes][:reviews].count).to eq(5)
        expect(movie[:data][:attributes][:reviews]).to be_a(Array)
    end
  end 
end