class Api::V1::ViewingPartiesController < ApplicationController
  before_action: authenticate_api_key

  def create

  end

  private

  def authenticate_api_key
    render json: { error: 'Invalid API key' }, status: :unauthorized unless params[:api_key].present?
  end
end
