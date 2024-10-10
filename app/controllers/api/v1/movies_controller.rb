class Api::V1::MoviesController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.params[:api_key] = Rails.application.credentials.dig(:tmdb, :key)
    end

    if params[:query].blank?
      response = conn.get("/3/movie/top_rated")
    else params[:query].present?
      response = conn.get("/3/search/movie") do |req|
        req.params[:query] = params[:query]
      end
    end

    massaged_response = JSON.parse(response.body, symbolize_names: true)

    if massaged_response[:results].present?
      movies = massaged_response[:results].first(20)
    else
      movies = []
    end

    render json: MovieSerializer.format_movie_list(movies)
  end
end
