require 'robust_layer_control_system'

class Player
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
  end

  # process workflow
  #  1. init sensor, collect env data
  #  2. use BFS compute by processor
  def process
    init_sensors
    processors_compute
  end

  def init_sensors
    WarriorSensor.instance.set_warrior @warrior
  end

  def processors_compute
    in_degrees = {}
    wires = ALL_WIRES.dup
    nodes = []

    wires.each do |wire_name|
      wire = Wires.find_or_create wire_name
      raise "illegal wire found: #{wire.name}, sources: #{wire.sources}, destinations: #{wire.destinations}" unless wire.legal?
      wire.destinations.each do |dest| 
        in_degrees[dest] ||= 0
        in_degrees[dest] += 1
      end
      nodes += wire.sources
      nodes += wire.destinations
    end
    nodes.uniq!
    zero_in_degree_nodes = nodes - in_degrees.keys

    # use BFS compute processor by processor
    bfs_compute(zero_in_degree_nodes, nodes, in_degrees)
  end

  def bfs_compute(zero_in_degree_nodes, nodes, in_degrees)
    raise "illegal control system: not a directed acyclic graph" if zero_in_degree_nodes.empty? && !nodes.empty?
    return if nodes.empty?

    zero_in_degree_nodes.each { |node| node.process }

    zero_in_degree_nodes.each do |node| 
      node.output_wires.each do |wire|
        wire.destinations.each do |dest|
          in_degrees[dest] -= 1
        end
      end
    end

    zero_in_degree_nodes = in_degrees.keys.select{ |node, in_degree| in_degree == 0}.keys
    zero_in_degree_nodes.each { |node| in_degrees.delete node }
    nodes -= zero_in_degree_nodes

    bfs_compute(zero_in_degree_nodes, in_degrees, nodes, in_degrees)
  end

  def post_process
    puts "************************* DONE "
  end

end
