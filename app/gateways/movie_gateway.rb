class MovieGateway
  def self.show_movie_details(movie)
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.params[:api_key] = Rails.application.credentials.dig(:tmdb, :key)
    end
    my_api_key = Rails.application.credentials.dig(:tmdb, :key)

    response = conn.get("/v1/movies/#{movie.id}?api_key=#{my_api_key}&append_to_response=reviews,credits")

    json = JSON.parse(response.body, symbolize_names: true)

  end
  
end