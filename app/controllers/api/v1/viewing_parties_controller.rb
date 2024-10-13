class Api::V1::ViewingPartiesController < ApplicationController
  before_action: authenticate_api_key

  def create
    host = User.find_by(api_key: params[:api_key])
    if host.nil?
      render json: { error: "Host w/ API key required" }, status: unauthorized
    end

    
  end

  private

  def authenticate_api_key
    render json: { error: 'Invalid API key' }, status: :unauthorized unless params[:api_key].present?
  end
end
