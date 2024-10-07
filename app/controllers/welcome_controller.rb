class WelcomeController < ApplicationController
  def index
    render :index
    puts "Reached WelcomeController#index"
  end
end
