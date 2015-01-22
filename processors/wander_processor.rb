require '../payload/moves_options'

class WanderProcessor < Processor
	#should processor know to which wires it connects?
	#seems processor must know it to do process. 
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