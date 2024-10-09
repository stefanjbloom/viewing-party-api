class Api::V1::MoviesController < ApplicationController
  def index
    movie = params[:movie]

    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:key]
    end
    response = conn.get("movie/top_rated")
    render json: MovieSerializer.format_movie_list(movie)
  end
end