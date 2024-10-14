class Api::V1::ViewingPartyInvitationsController < ApplicationController

  def create
    host = User.find_by(api_key: params[:api_key])
    unless host
      return render json: { error: "Invalid API key" }, status: :unauthorized
    end

    existing_viewing_party = ViewingParty.find_by(id: params[:viewing_party_id], host: host)

    if existing_viewing_party.nil?
      return render json: { error: "Invalid viewing party ID" }, status: :not_found
    end

    invitee = User.find_by(id: params[:invitees_user_id])

    if invitee.nil?
      return render json: { error: "Invalid user ID" }, status: :not_found
    end

    ViewingPartyUser.create!(viewing_party: existing_viewing_party, user: invitee)

    render json: ViewingPartySerializer.new(existing_viewing_party), status: :ok
  end
end
