class Player
	FULL_HEALTH = 20
	DIRECTIONS = [:foward, :right, :backward, :left]

	def initialize
		@warrior = nil
		@current_health = nil
		@prev_health = nil
		@direction = nil
	end

	#strategy: destroy everything between me and stairs
  def play_turn(warrior)
  	@warrior = warrior
  	remember_this_turn_info
  	return rest! if !health_full? && !be_attacked_last_turn?
  	return attack! if feel.enemy? 
  	return walk! if feel.empty?
  	walk! suitable_direction
  end

  def remember_this_turn_info
  	@prev_health = @current_health
  	@current_health = @warrior.health
  	@direction = @warrior.direction_of_stairs
  end

  def feel
  	@warrior.feel @direction
  end

  def walk!
  	@warrior.walk! @direction
  end

  def attack!
  	@warrior.attack! @direction
  end

  def rest!
  	@warrior.rest!
  end

  def health_full?
  	@warrior.health == FULL_HEALTH
  end

  def be_attacked_last_turn?
  	@current_health < @prev_health
  end

  def suitable_direction
  	stairs_direction_idx = DIRECTIONS.find_index(@direction)
  	idx = stairs_direction_idx

  	(0..(DIRECTIONS.length - 1)).each do |increment|
  		idx = (increment + stairs_direction_idx) % DIRECTION.length
  		break if @warrior.feel(DIRECTIONS[idx]).empty?
  	end
  	
  	idx
  end
end
