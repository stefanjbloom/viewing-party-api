class MovieGateway
  def self.conn
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.params[:api_key] = Rails.application.credentials.dig(:tmdb, :key)
    end
  end

  def self.get_top_rated_movies
    conn.get("/3/movie/top_rated")
  end

  def self.search_movies(query)
    conn.get("/3/search/movie") do |req|
      req.params[:query] = query
    end
  end

  def self.show_movie_details(movie_id)
    my_api_key = Rails.application.credentials.dig(:tmdb, :key)
    response = conn.get("/3/movie/#{movie_id}?api_key=#{my_api_key}&append_to_response=reviews,credits")

    json = JSON.parse(response.body, symbolize_names: true)
    movie_obj = Movie.new(json)
    movie_obj.movie_poro_response
  end
end