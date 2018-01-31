class RoverFleetController < ApplicationController
  def index
		@rover_fleet = RoverFleet.new
  end

  def result
  	@rover_fleet = RoverFleet.new(rover_fleet_params)
  	respond_to do |format|
      if @rover_fleet.valid?
           
        @output = @rover_fleet.process_input()

		  	# prepare output to be presented nicely in html format
		  	@output = @output.gsub! "\n", "<br />"

		  	@output = @output.html_safe 
        
        format.html { render :result }    
      else
           
        format.html { render :index }
       
      end
    end
  	
  end

  private
	  def rover_fleet_params
	    params.require(:rover_fleet).permit(:input)
	  end
end
