require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "happy paths" do
    it "#index can retrieve 20 top rated movies" do
    json_response = File.read('spec/fixtures/tmdb_movie_query.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=8a3d711a9dffaae8269c99fbbbc192df").
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

    it '#show can return a max 20 movies using ?search=' do
    
    end
  end
end
