class Api::V1::ViewingPartiesController < ApplicationController
  before_action :authenticate_api_key

  def create
    host = User.find_by(api_key: params[:api_key])
    unless host
      return render json: { error: "Host w/ API key required" }, status: :unauthorized
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
    # binding.pry
    invitees.each do |invitee|
      ViewingPartyUser.create!(viewing_party: viewing_party, user: invitee)
    end

    render json: ViewingPartySerializer.new(viewing_party), status: :created
  end

  private

  def authenticate_api_key
    render json: { error: 'Invalid API key' }, status: :unauthorized unless params[:api_key].present?
  end
end
