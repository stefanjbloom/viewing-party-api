class Api::V1::ViewingPartiesController < ApplicationController

  def create
    unless params[:api_key].present?
      return render json: { error: "No API key means no movie party!" }, status: :unauthorized
    end

    host = User.find_by(api_key: params[:api_key])
    unless host
      return render json: { error: "Invalid API key" }, status: :unauthorized
    end
    
    if params[:end_time] < params[:start_time]
      return render json: { error: "Party can't end before it starts" }, status: :unprocessable_entity
    end

    viewing_party = ViewingParty.create!(
      name: params[:name],
      start_time: params[:start_time],
      end_time: params[:end_time],
      movie_id: params[:movie_id],
      movie_title: params[:movie_title],
      host: host
    )

    invitee_ids = params[:invitees].map { |invitee| invitee[:id] }
    invitees = User.where(id: invitee_ids)

    invitees.each do |invitee|
      ViewingPartyUser.create!(viewing_party: viewing_party, user: invitee)
    end

    start_time = DateTime.parse(params[:start_time])
    end_time = DateTime.parse(params[:end_time])
    party_duration = ((end_time - start_time) * 24 * 60).to_i
    
    movie = MovieGateway.show_movie_details(params[:movie_id].to_i)[:data][:attributes]
    if party_duration < movie[:runtime]
      return render json: { error: "Party duration can't be less than the movie runtime" }, status: :unprocessable_entity
    end

    render json: ViewingPartySerializer.new(viewing_party), status: :created
  end
end
