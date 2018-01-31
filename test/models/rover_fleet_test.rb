require 'test_helper'

class RoverFleetTest < ActiveSupport::TestCase

  test "should return correct output given correctly formatted input" do
	  input = "5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM"
	  expected_ouput = "1 3 N\n5 1 E\n"
	  rover_fleet = RoverFleet.new({input: input})
	  output = rover_fleet.process_input
	  assert_equal(expected_ouput, output)
	end

	test "should raise an exception if a move leads to an out-of-bound position" do
	  inputs = [
  		# final x coordinate is less than 0
  		"5 5\n1 2 N\nLMMMLMLMM\n3 3 E\nMMRMMRMRRM",

  		# final x coordinate is greater than upper right's x coordinate
  		"5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMMMMRMRRM",

  		# final y coordinate is less than 0
  		"5 5\n1 2 N\nLMMMLMLMM\n3 3 E\nMMRMMMMMRRM",

  		# final y coordinate is greater than upper right's y coordinate
  		"5 5\n1 2 N\nLMMMLMLMMMMM\n3 3 E\nMMRMMMMMRRM"
	  ]

	  inputs.each { |e| raises_argument_error(e)  }
	end

	test "should raise an exception if a rover's starting position is out of bound" do
	  
	  inputs = [
  		# starting x coordinate is less than 0
	  	"5 5\n-1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# starting x coordinate is greater than upper right's x coordinate
	  	"5 5\n6 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

			# starting y coordinate is less than 0	
			"5 5\n1 -1 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

			# starting y coordinate is greater than upper right's y coordinate
		 	"5 5\n1 6 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM"
	  ]

	  inputs.each { |e| raises_argument_error(e)  }
	end

	test "should raise an exception if a rover's starting position has incorrect format" do
	  input = "5 5\n1 2 t\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM"
	  raises_argument_error(input)
	  inputs = [
  		# x coordinate is not an integer
	  	"5 5\na 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# y coordinate is not an integer
	  	"5 5\n1 a N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# heading is not a compass direction
	  	"5 5\n1 2 a\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# starts with a space
	  	"5 5\n 1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# ends with a space
	  	"5 5\n1 2 N \nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# coordinates separated by more than one space
	  	"5 5\n1  2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",
	  	"5 5\n1 2  N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",
	  ]

	  inputs.each { |e| raises_argument_error(e)  }
	end

	test "should raise an exception if a rover's instructions are in incorrect format" do

	  inputs = [
  		# instructions contain a space
	  	"5 5\n1 2 N\nLMLM LMLMM\n3 3 E\nMMRMMRMRRM",

	  	# instructions start with a space
	  	"5 5\n1 2 N\n LMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# instructions end with a space
	  	"5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM ",

	  	# instructions contain an invalid move
	  	"5 5\n1 2 N\nLMLrLMLMM\n3 3 E\nMMRMMRMRRM",
	  ]

	  inputs.each { |e| raises_argument_error(e)  }
	end

	test "should raise an exception if input is empty" do
	  input = nil
	  raises_argument_error(input)
	end

	test "should raise an exception if number of lines is less than 3" do
	  input = "5 5\n1 2 N"
	  raises_argument_error(input)
	end

	test "should raise an exception if number of lines is not odd" do
	  input = "5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM\n3 3 E",
	  raises_argument_error(input)
	end

	test "should raise an exception if upper-right coordinates in incorrect format" do
	  inputs = [
  		# x coordinate is < 0
	  	"-5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# y coordinate is < 0
	  	"5 -5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# x coordinate is not an integer
	  	"a 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

	  	# y coordinate is not an integer
	  	"5 c\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

			# more than one space in between coordinates
			"5  5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

			# starts with a space
		 	" 5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM",

		 	# ends with a space
		 	"5 5 \n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM"
	  ]

	  inputs.each { |e| raises_argument_error(e)  }
	end

	private
		def raises_argument_error(input)
			rover_fleet = RoverFleet.new({input: input})
		  assert_raises(ArgumentError) {
		  	output = rover_fleet.process_input
	  	}
		end

end
