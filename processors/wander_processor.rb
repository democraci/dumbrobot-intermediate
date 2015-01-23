require '../payload/moves_options'
require '../wires/wire'
require 'processor'

class WanderProcessor < Processor
	include Singleton

	Wires.add_destinations_to_wire(:warrior, self.instance)

	def process
		warrior = find_input_wire(:warrior).outcome
		options = MovesOptions.new

		DIRECTIONS.each do |direction|
			unless warrior.feel(direction).empty? || warrior.feel(direction).stairs?
				options.drop_moves_by_direction(:walk!, direction)	
			end
		end

		outcome = options
	end
end