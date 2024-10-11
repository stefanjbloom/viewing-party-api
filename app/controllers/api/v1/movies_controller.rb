class Api::V1::MoviesController < ApplicationController
  def index
    if params[:query].blank?
      response = MovieGateway.get_top_rated_movies
    else params[:query].present?
      response = MovieGateway.search_movies(params[:query])
    end

    massaged_response = JSON.parse(response.body, symbolize_names: true)

    if massaged_response[:results].present?
      movies = massaged_response[:results].first(20)
    else
      movies = []
    end

    render json: MovieSerializer.format_movie_list(movies)
  end

  def show
    movie_data = MovieGateway.show_movie_details(params[:id])
    render json: movie_data
  end
end