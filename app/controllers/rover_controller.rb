class RoverController < ApplicationController
  def index
		@rover_fleet = RoverFleet.new
  end
  def result
		render plain: params[:rover_fleet].inspect
  end
end
