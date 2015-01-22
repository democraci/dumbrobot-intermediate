class Player
	FULL_HEALTH = 20
	DIRECTIONS = [:forward, :right, :backward, :left]

	def initialize
		@warrior = nil
		@current_health = nil
		@prev_health = nil
	end

  def play_turn(warrior)
  	pre_process(warrior)
  	process
    post_process
  end

  def pre_process(warrior)
    @warrior = warrior
    @prev_health = @current_health
    @current_health = @warrior.health
    init_sensors
  end

  def init_sensors
    
  end

  def init_processors
    @wander_processor = WanderProcessor.new
    @motor_processor = MotorProcessor.new
  end

  def init_wires
    Wires.add_sources_to_wire()
  end

  def process_layers
    avoid_bump
  end

  def post_process
  end

end
