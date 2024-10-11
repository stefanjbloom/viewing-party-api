class Movie < ApplicationRecord
  attr_reader :title,
              :release_year,
              :vote_average,
              :runtime,
              :genres,
              :summary,
              :cast,
              :total_reviews,
              :reviews

  def initialize(movie_data)
    @title = movie_data[:original_title]
    @release_year = convert_year(movie_data[:release_date])
    @vote_average = movie_data[:vote_average]
    @runtime = calc_time(movie_data[:runtime])
    @genres = array_genres(movie_data[:genres])
    @summary = movie_data[:overview]
    @cast = array_cast(movie_data[:credits][:cast]).limit(10)
    @total_reviews = movie_data[:reviews][:total_results]
    @reviews = array_reviews(movie_data[:reviews][:results])
  end

  private
  def convert_year(release_year)
    release_date.split("-").first
  end

  def calc_time(runtime)
    # convert runtime from minutes integer to "#{hours} hours, #{minutes} minutes" 
    hours = runtime / 60
    minutes = runtime % 60
    "#{hours} hours, #{minutes} minutes"
  end

  def array_genres

  end

  def array_cast
# if known_for_department == "Acting" then push into array[] of hashes{character: "", actor: ""}
  end

  def array_reviews

  end
end