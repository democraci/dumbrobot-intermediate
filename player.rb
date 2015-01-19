class Player
	FULL_HEALTH = 20
	DIRECTIONS = [:forward, :right, :backward, :left]

	def initialize
		@warrior = nil
		@current_health = nil
		@prev_health = nil
		@direction = nil
	end

	#strategy: 
	#bind every enemy first
	#then destroy everything between me and stairs
  def play_turn(warrior)
  	@warrior = warrior
  	remember_this_turn_info

  	return rest! if !health_full? && !be_attacked_last_turn?
  	return bind! if be_attacked_last_turn? && !can_kill_all_enemy?
  	return attack! if !feel.empty?
  	return walk! if feel.empty?
  end

  def remember_this_turn_info
  	@prev_health = @current_health
  	@current_health = @warrior.health
  	@direction = @warrior.direction_of_stairs
  end

  def feel(direction=nil)
  	direction ||= @direction
  	@warrior.feel direction
  end

  def walk!(direction=nil)
  	direction ||= @direction
  	@warrior.walk! direction
  end

  def bind!(direction=nil)
  	direction ||= @direction
  	@warrior.bind! enemy_direction
  end

  def attack!(direction=nil)
  	direction ||= @direction
  	@warrior.attack! direction
  end

  def rest!
  	@warrior.rest!
  end

  def health_full?
  	@warrior.health == FULL_HEALTH
  end

  def be_attacked_last_turn?
  	return true if @prev_health.nil?
  	@warrior.health < @prev_health
  end

  def can_kill_all_enemy?
  	enemy_number = DIRECTIONS.each.count do |direction|
  		@warrior.feel(direction).enemy?
 		end

 		@warrior.health > enemy_number * 9
  end

  def suitable_direction
  	stairs_direction_idx = DIRECTIONS.find_index(@direction)
  	idx = stairs_direction_idx

  	(0..(DIRECTIONS.length - 1)).each do |increment|
  		idx = (increment + stairs_direction_idx) % DIRECTIONS.length
  		break if @warrior.feel(DIRECTIONS[idx]).empty?
  	end

  	DIRECTIONS[idx]
  end

  def enemy_direction
  	DIRECTIONS.each do |direction|
  		return direction if @warrior.feel(direction).enemy?
  	end
  	:forward
  end

end
