class Movie
  attr_reader :id,
              :title,
              :release_year,
              :vote_average,
              :runtime,
              :genres,
              :summary,
              :cast,
              :total_reviews,
              :reviews

  def initialize(movie_data)
    @id = movie_data[:id]
    @title = movie_data[:original_title]
    @release_year = convert_year(movie_data[:release_date])
    @vote_average = movie_data[:vote_average]
    @runtime = calc_time(movie_data[:runtime])
    @genres = array_genres(movie_data[:genres])
    @summary = movie_data[:overview]
    @cast = array_cast(movie_data[:credits][:cast]).first(10)
    @total_reviews = movie_data[:reviews][:total_results]
    # binding.pry
    @reviews = array_reviews(movie_data[:reviews][:results]).first(5)
  end

  def movie_poro_response
    {
      data: {
        id: @id,
        type: "movie",
        attributes: {
          title: @title,
          release_year: @release_year,
          vote_average: @vote_average,
          runtime: @runtime,
          genres: @genres,
          summary: @summary,
          cast: @cast,
          total_reviews: @total_reviews,
          reviews: @reviews
        }
      }
    }
  end

  private

  def convert_year(release_year)
    release_year.split("-").first.to_i
  end

  def calc_time(runtime)
    hours = runtime / 60
    minutes = runtime % 60
    "#{hours} hours, #{minutes} minutes"
  end

  def array_genres(genres)
    genres.map { |genre| genre[:name] }
  end

  def array_cast(cast_members)
    cast_members.map { |cast_member| { character: cast_member[:character], actor: cast_member[:name] }}
  end

  def array_reviews(reviewers)
    reviewers.map { |reviewer| {author: reviewer[:author], review: reviewer[:content]}}
  end
end