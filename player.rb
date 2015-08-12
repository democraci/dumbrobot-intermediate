require 'moves_options'
require 'history'
require 'pry'

def debug_msg(msg)
  puts "DEBUG:  #{msg}"
end

class Player
  AVOID = 5
  REST = 4
  UNBIND = 3
  PLAN = 2

  def play_turn(warrior)
  	init_env(warrior)
  	process
    take_action
  end

  # init env
  def init_env(warrior)
    @warrior = warrior
    @current_move_opts = MovesOptions.new
  end

  def process
    # process each layer
    avoid_unneccessary_move
    rest_if_tired
    unbind_captives
    destroy_nearby_enemy
  end

  def avoid_unneccessary_move
    avoid_unneccessary_attack
    avoid_goto_stairs_unready
    avoid_unneccessary_walk
    avoid_unneccessary_bind
    avoid_unneccessary_rescue
    avoid_unneccessary_rest
  end

  def avoid_unneccessary_attack
    each_direction do |direction|
      unless @warrior.feel(direction).enemy?
        @current_move_opts.drop_moves_by_direction(:attack!, direction)
      end
    end
  end

  def avoid_goto_stairs_unready
    remain_spaces = @warrior.listen
    binding.pry
    return if remain_spaces.empty?

    unless remain_spaces.find { |space| !space.stairs? }.empty?
      each_direction do |direction|
        next unless @warrior.feel(direction).stairs?
        @current_move_opts.drop_moves_by_direction(:walk!, direction)
      end
    end
  end

  def avoid_unneccessary_walk
    each_direction do |direction|
      unless @warrior.feel(direction).empty?
        @current_move_opts.drop_moves_by_direction(:walk!, direction)
      end
    end
  end

  def avoid_unneccessary_bind
    each_direction do |direction|
      unless @warrior.feel(direction).enemy?
        @current_move_opts.drop_moves_by_direction(:bind!, direction)
      end
    end
  end

  def avoid_unneccessary_rescue
    each_direction do |direction|
      unless @warrior.feel(direction).captive?
        @current_move_opts.drop_moves_by_direction(:rescue!, direction)
      end
    end
  end

  def avoid_unneccessary_rest
    if health_full? 
      @current_move_opts.drop_moves(:rest!)
    end
  end

  def rest_if_tired
    return if health_full?
    return if nearby_active_enemy_cnt != 0
    return if @warrior.health > History.max_health/4 && History.move_history.last[0] != :rest!
    @current_move_opts.emphasize_moves_by_direction(:rest!, :here, REST)
  end

  def unbind_captives
    each_direction do |direction|
      @current_move_opts.emphasize_moves_by_direction(:rescue!, direction, UNBIND) if captive_innocent?(@warrior.feel(direction))
    end
  end

  def destroy_nearby_enemy
    case nearby_active_enemy_cnt
    when 1
      each_direction do |direction|
        @current_move_opts.emphasize_moves_by_direction(:attack!, direction, PLAN) if active_enemy?(@warrior.feel(direction))
      end
    when 0
      each_direction do |direction|
        @current_move_opts.emphasize_moves_by_direction(:attack!, direction, PLAN) if captive_enemy?(@warrior.feel(direction))
      end
      @current_move_opts.emphasize_moves_by_direction(:walk!, direction_of_next_goal, PLAN)
    else
      each_direction do |direction|
        @current_move_opts.emphasize_moves_by_direction(:bind!, direction, PLAN) if active_enemy?(@warrior.feel(direction))
      end
    end
  end

  def nearby_active_enemy_cnt
    cnt = 0
    each_direction do |direction|
      space = @warrior.feel(direction)
      cnt += 1 if active_enemy?(space)
    end

    cnt
  end

  def active_enemy?(space)
    space.enemy? && !space.captive? && History.enemy_locations.add(space.location)
  end

  def captive_enemy?(space)
    space.captive? && History.enemy_locations.include?(space.location)
  end

  def captive_innocent?(space)
    space.captive? && !History.enemy_locations.include?(space.location)
  end

  def direction_of_next_goal
    @warrior.direction_of(@warrior.listen.first)
  rescue
    @warrior.direction_of_stairs
  end


  def goto_nearby_stairs
    MovesOptions::DIRECTIONS.each do |direction|
      next unless @warrior.feel(direction).stairs?
      
      (MovesOptions::MOVES - [:walk!]).each do |move|
        @current_move_opts.drop_moves(move)
      end

      (MovesOptions::DIRECTIONS - [direction]).each do |dir|
        @current_move_opts.drop_moves_by_direction(:walk!, dir)
      end
    end
  end

  def take_action
    candidate_moves = @current_move_opts.candidate_moves

    raise "No available action found" if candidate_moves.length == 0

    move = candidate_moves[rand(candidate_moves.length)]
    History.update_history(@warrior, move)


    if move.first == :rest!
      @warrior.send(:rest!)
    else
      @warrior.send(move[0], move[1])
    end
  end

  def health_full?
    return true if History.first_round?

    return History.max_health == @warrior.health
  end

  def each_direction
    MovesOptions::DIRECTIONS.each do |direction|
      yield direction if block_given?
    end
  end

end
