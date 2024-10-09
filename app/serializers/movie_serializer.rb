class MovieSerializer
  include JSONAPI::Serializer
  attributes :title, :vote_average

  def self.format_movie_list(movies).limit(20)
    { data:
      movies.map do |movie|
        {
          id: movie.id.to_s,
          type: "movie",
          attributes: {
            title: movie.title,
            vote_average: movie.vote_average
          }
        }
      end
    }
  end
end