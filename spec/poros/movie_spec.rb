require 'rails_helper'

RSpec.describe Movie do
  it 'initializes with correctly parsed attributes' do
    movie_data = {
      original_title: "Interstellar",
      release_date: "2014-11-05",
      vote_average: 8.4,
      runtime: 169,
      genres: [{name: "Adventure"}, {name: "Drama"}, {name: "Science Fiction"}],
      overview: "A group of explorers...",
      credits: {
        cast: [
          {character: "Cooper", name: "Matthew McConaughey"},
          {character: "Brand", name: "Anne Hathaway"},
          {character: "Murph", name: "Jessica Chastain"}
        ]
      },
      contents: {
        total_results: 5,
        results: [
          {author: "corgiman", content: "test1"},
          {author: "corgilady", content: "Ptest2"},
          {author: "corgiboy", content: "Ptest3"},
          {author: "corgigal", content: "Ptest4"},
          {author: "corgo", content: "Ptest5"}
        ]
      }
    }

    movie = Movie.new(movie_data)

    expect(movie.title).to eq("Interstellar")
    expect(movie.release_year).to eq(2014)
    expect(movie.vote_average).to eq(8.4)
    expect(movie.runtime).to eq("2 hours, 10 minutes")
    expect(movie.genres).to eq(["Adventure", "Drama", "Science Fiction"])
    expect(movie.summary).to eq("A group of explorers...")
    expect(movie.cast).to eq([{character: "Cooper", actor: "Matthew McConaughey"}, {character: "Brand", actor: "Anne Hathaway"}, 
      {character: "Murph", actor: "Jessica Chastain"}])
    expect(movie.cast.count).to eq(10)
    expect(movie.total_reviews).to eq(16)
    expect(movie.reviews).to eq([{author: "corgiman", review: "test1"},
      {author: "corgilady", review: "Ptest2"}, {author: "corgiboy", review: "Ptest3"},
      {author: "corgigal", review: "Ptest4"},{author: "corgo", review: "Ptest5"}])
  end
end