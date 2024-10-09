class Api::V1::MoviesController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.params[:api_key] = Rails.application.credentials.dig(:tmdb, :key)
    end
    var = Rails.application.credentials.dig(:tmdb, :key)
    response = conn.get("/3/movie/top_rated")
    # binding.pry
    movies = JSON.parse(response.body, symbolize_names: true)[:results].first(20)

    render json: MovieSerializer.format_movie_list(movies)
  end
end