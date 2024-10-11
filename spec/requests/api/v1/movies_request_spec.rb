require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "happy paths" do
    it "#index can retrieve 20 top-rated movies" do
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
        expect(movie[:attributes][:title]).to include("The Lord of the Rings")
      end
    end

    it '#find can return details of a single movie by id' do
      api_key = Rails.application.credentials.dig(:tmdb, :key)
      json_response = File.read('spec/fixtures/tmdb_find_query.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/157336?api_key=#{api_key}&append_to_response=reviews,credits").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v2.10.1'
          }).
        to_return(status: 200, body: json_response, headers: {})

      get "/api/v1/movies/157336"

      json = JSON.parse(response.body, symbolize_names: true)
      movie = json[:data]

      expect(movie[:id]).to eq(157336)
      expect(movie[:type]).to eq("movie")
      expect(movie[:attributes]).to be_a(Hash)
      expect(movie[:attributes][:title]).to eq("Interstellar")
      expect(movie[:attributes][:release_year]).to eq(2014)
      expect(movie[:attributes][:vote_average]).to eq(8.40)
      expect(movie[:attributes][:runtime]).to eq("2 hours, 49 minutes")
      expect(movie[:attributes][:genres]).to eq(["Adventure", "Drama", "Science Fiction"])
      expect(movie[:attributes][:summary]).to eq("The adventures of a group of explorers...")
      expect(movie[:attributes][:cast].size).to eq(10)
      expect(movie[:attributes][:cast]).to be_a(Array)
      expect(movie[:attributes][:total_reviews]).to eq(16)
      expect(movie[:attributes][:reviews].size).to eq(5)
      expect(movie[:attributes][:reviews]).to be_a(Array)
    end
  end

  describe "sad paths" do
    it '#index returns top-rated movies if ?query=<nothing provided by user>' do
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
  end
end