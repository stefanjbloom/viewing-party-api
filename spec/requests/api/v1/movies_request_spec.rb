require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "happy paths" do
    it "#index can retrieve 20 top rated movies" do
      api_key = Rails.application.credentials.dig(:tmdb, :key)
      json_response = File.read('spec/fixtures/tmdb_movie_query.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{api_key}").
        with(
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
          }).
        to_return(status: 200, body: json_response, headers: {})

        get "/api/v1/movies"

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data].count).to eq(20)

        json[:data].each do |movie|
          expect(movie).to have_key(:id)
          expect(movie[:type]).to eq("movie")
          expect(movie[:attributes]).to have_key(:title)
          expect(movie[:attributes]).to have_key(:vote_average)
        end
      end
    end

    it '#index can retrieve movies based on search query param' do
      api_key = Rails.application.credentials.dig(:tmdb, :key)
      json_response = File.read('spec/fixtures/tmdb_search_query.json')
      stub_request(:get, "https://api.themoviedb.org/3/search/movie?query=The%20Lord%20of%20the%20Rings&api_key=#{api_key}").
        with(
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
          }).
        to_return(status: 200, body: json_response, headers: {})
        
        get "/api/v1/movies?query=The%20Lord%20of%20the%20Rings"

        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)
        movies = json[:data]

        movies.each do |movie|
          expect(movies[:attributes][:title]).to include("The Lord of the Rings")
        end
      end
    end
  # end

  describe "sad paths" do
    it '#index returns top rated movies if ?query=<nothing provided by user>' do
      api_key = Rails.application.credentials.dig(:tmdb, :key)
      json_response = File.read('spec/fixtures/tmdb_movie_query.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{api_key}").
        with(
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
          }).
        to_return(status: 200, body: json_response, headers: {}) 

        get "/api/v1/movies?query="

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data].count).to eq(20)

        json[:data].each do |movie|
          expect(movie).to have_key(:id)
          expect(movie[:type]).to eq("movie")
          expect(movie[:attributes]).to have_key(:title)
          expect(movie[:attributes]).to have_key(:vote_average)
      end
    end
  # end
end
