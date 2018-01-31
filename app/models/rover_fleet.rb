class RoverFleet
	include ActiveModel::Model
  attr_accessor :input, :output

  # fields validation.
  validates :input, presence: true

  # class constants
  CompassDirections = ['N', 'E', 'S', 'W']
  ValidMoves = ['L', 'R', 'M']

	def process_input
		if(self.input.nil?)
			raise ArgumentError.new('Input cannot be empty')
		end

		self.output = ""

		# ignore carriage returns which could be present if input came through 
		# textarea
		self.input = self.input.gsub "\r", ""

		# split input by newline character into lines
		lines = self.input.split("\n")

		if lines.length < 3
			raise ArgumentError.new('Input must have at least 3 lines')
		end

		if(lines.length % 2 != 1)
			raise ArgumentError.new('Number of lines must be odd')
		end

		# first line has upper-right coordinates of plateau
		upper_right = lines[0].split(" ")

		# ensure upper right coordinates are in correct format
		if (/^[0-9]+ [0-9]+$/ =~ lines[0]).nil?
			raise ArgumentError.new('First line must have upper-right integer 
				coordinates separated by exactly one space')
		end

		upper_right.map! { |c| c.to_i }
		lines.shift
		move_rovers(upper_right, lines)

		return self.output
	end

	private
		def move_rovers(upper_right, lines)
			if lines.length === 0
				return
			end

			# first line has rover's current position
			current_position = lines[0].split(" ")

			# current position must be in right format
			if (/^[0-9]+ [0-9]+ [NESW]$/ =~ lines[0]).nil?
				raise ArgumentError.new('Starting rover position must be in right format')
			end
			heading = current_position[2]
			current_position = current_position[0..1].map! { |c| c.to_i }
			current_position.push(heading)

			# validate starting position
			if(!validate_position(upper_right, current_position))
				raise ArgumentError.new("Move results in an out of bound position")
			end

			# second line has instructions for how the rover should be moved
			# split it into a character array
			instructions = lines[1].split("")

			# instructions must be in right format
			if (/^[LRM]+$/ =~ lines[1]).nil?
				raise ArgumentError.new('Rover instructions must be in correct format')
			end

			execute_instructions(upper_right, current_position, instructions)

			return move_rovers(upper_right, lines[2..(lines.length-1)])
		end

		# Position's (x, y) coordinates must be within plateau's bounds and heading
		# must be a valid compass direction
		def validate_position(upper_right, current_position)
			return current_position[0] >= 0 && current_position[0] <= upper_right[0] &&
			current_position[1] >= 0 && current_position[1] <= upper_right[1] && 
			!CompassDirections.index(current_position[2]).nil?
			
		end

		def execute_instructions(upper_right, current_position, instructions)
			if instructions.length === 0
				self.output += current_position.join(" ") + "\n"
				return
			end

			instruction = instructions[0]

			if instruction === 'M'
				current_position = change_grid(current_position)
			else
				current_position = change_heading(current_position, instruction)
			end

			if(!validate_position(upper_right, current_position))
				raise ArgumentError.new("Move results in an out of bound position")
			end

			instructions.shift
			return execute_instructions(upper_right, current_position, instructions)
		end

		def change_grid(current_position)
			case current_position[2]
			when "N"
				current_position[1] += 1
			when "E"
				current_position[0] += 1
			when "S"
				current_position[1] -= 1
			when "W"
				current_position[0] -= 1
			end

			return current_position
		end

		def change_heading(current_position, instruction)
			compass_index = CompassDirections.index(current_position[2])

			compass_index = instruction === 'L' ? compass_index - 1 : compass_index + 1

			# when rover is moved left past North, new heading becomes West
			if compass_index < 0
				compass_index = CompassDirections.length - 1
			end

			# when rover is moved right past West, new heading becomes North
			if compass_index > CompassDirections.length - 1
				compass_index = 0
			end

			current_position[2] = CompassDirections[compass_index]
			return current_position
		end
end
