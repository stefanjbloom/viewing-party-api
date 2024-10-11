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
# Movie Details
# This endpoint is NOT authenticated. This endpoint should:

# Return details about a movie’s

# Title title[:original_title]
# Release year release_year[:release_date] (need to format it so that its JUST year)
# Vote average vote_average[:vote_average]
# Runtime in hours & minutes GET THIS FROM IMDB
# Genre(s) associated to movie GET THIS FROM IMDB
# Summary description summary[:overview]
# List the first 10 cast members IMDB(characters & actors) cast[:character = name, :actor =actor.name]
# Count the total reviews total_reviews[:vote_count]
# List of first 5 reviews (author and review) 
# Include the movie’s ID (in the Movie DB API system, not your application) in the path
# Note: Retrieving this information from the Movie DB API could take up to 3 different network requests (unless you find a shortcut!)
# Example JSON response:

# {
#   "data": {
#       "id": "278",
#       "type": "movie",
#       "attributes": {
#         "title": "The Shawshank Redemption",
#         "release_year": 1994,
#         "vote_average": 8.706,
#         "runtime": "2 hours, 22 minutes",
#         "genres": ["Drama", "Crime"],
#         "summary": "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
#         "cast": [
#           {
#             "character": "Andy Dufresne",
#             "actor": "Tim Robbins"
#           },
#           {
#             "character": "Ellis Boyd 'Red' Redding",
#             "actor": "Morgan Freeman"
#           } 
#           // ... 10 of these! (max)
#         ],
#         "total_reviews": 14,
#         "reviews": [
#           {
#             "author": "elshaarawy",
#             "review": "very good movie 9.5/10 محمد الشعراوى"
#           },
#           {
#             "author": "John Chard",
#             "review": "Some birds aren't meant to be caged.\r\n\r\nThe Shawshank Redemption is written and directed by Frank Darabont. It is an adaptation of the Stephen King novella Rita Hayworth and Shawshank Redemption..."
#           }
#           // ... 5 of these (max)
#         ]
#       }
#     }
# }