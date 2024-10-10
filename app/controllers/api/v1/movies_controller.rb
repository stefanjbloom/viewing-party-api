class Api::V1::MoviesController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.params[:api_key] = Rails.application.credentials.dig(:tmdb, :key)
    end
    
    if params[:query].blank?
      return render json: { message: "Please enter a search query", status: 422 }, status: :unprocessable_entity
    end

    if params[:query].present?
      response = conn.get("/3/search/movie") do |req|
        req.params[:query] = params[:query]
      end
    else
      response = conn.get("/3/movie/top_rated")
    end

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    if parsed_response[:results].present?
      movies = parsed_response[:results].first(20)
    else
      movies = []
    end

    render json: MovieSerializer.format_movie_list(movies)
  end
end
