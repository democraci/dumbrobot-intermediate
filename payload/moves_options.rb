DIRECTIONS = [:forward, :right, :backward, :left]
MOVES = [:rest!, :rescue!, :bind!, :acttack!, :walk!]
EXTENDED_DIRECTIONS = [:forward, :right, :backward, :left, :here]

#TODO class name and method name seems a little wired
class MovesOptions
	def initialize 
		@options = {
			:rest! => {
				:here => 1
			},
			:rescue! => {
				:forward => 1,
				:right => 1,
				:backward => 1,
				:left => 1
			},
			:bind! => {
				:forward => 1,
				:right => 1,
				:backward => 1,
				:left => 1
			},
			:attack! => {
				:forward => 1,
				:right => 1,
				:backward => 1,
				:left => 1
			},
			:walk! => {
				:forward => 1,
				:right => 1,
				:backward => 1,
				:left => 1
			},
		} 
	end

	def drop_moves(moves)
		EXTENDED_DIRECTIONS.each do |direction|
			drop_moves_by_direction(moves, direction)
		end
	end

	def drop_moves_by_direction(moves, direction)
		@options[moves][direction] and @options[moves][direction] = 0
	end

	def moves_of_direction_droped?(moves, direction)
		@options[moves][direction] and @options[moves][direction] == 0 	
	end

	def emphasize_moves_by_direction(moves, direction, point)
		@options[moves][direction] and @options[moves][direction] += point
	end

	def score_of_moves_by_direction(moves, direction)
		@options[moves][direction]
	end

	def candidate_moves
		max_score = max_score_of_all_moves
		candidates = []

		each_option do |moves, direction|
			candidates << [moves, direction] if score_of_moves_by_direction(moves, direction) == max_score
		end

		candidates
	end

	private

	def each_option
		MOVES.each do |moves|
			EXTENDED_DIRECTIONS.each do |direction|
				yield moves, direction if @options[moves][direction]
			end
		end
	end

	def max_score_of_all_moves
		max_score = 0

		each_option do |moves, direction|
			max_score = @options[moves][direction] if max_score < @options[moves][direction] 
		end

		max_score
	end

	def self.combine(a, b)
		result = new
		
		MOVES.each do |moves|
			EXTENDED_DIRECTIONS.each do |direction|
				if a.moves_of_direction_droped?(moves, direction) || b.moves_of_direction_droped?(moves, direction)
					result.drop_moves_by_direction(moves, direction)
				else
					[a,b].each { |action| result.emphasize_moves_by_direction(moves, direction,
						action.score_of_moves_in_direction(moves, direction)) }
				end
			end
		end

		result
	end

end