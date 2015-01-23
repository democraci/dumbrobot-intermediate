require 'singleton'
require File.dirname(__FILE__) + '/../payload/moves_options'
require File.dirname(__FILE__) + '/../wires/wire'
require File.dirname(__FILE__) + '/processor'

class MotorProcessor < Processor
	include Singleton

	#process method shall know the info of wires the processor connets to, which is strong coupled
	#so we need declare the connection here
	Wires.add_destinations_to_wire(:command, self.instance)
	Wires.add_destinations_to_wire(:warrior, self.instance)

	def process
		command_options = find_input_wire(:command).outcome
		warrior = find_input_wire(:warrior).outcome

		command = random_pick(command_options.candidate_moves)
		return (puts "cannot find a workable moves") if command.nil?
		command[0] == :rest! ? warrior.send(command[0]) : warrior.send(command[0], command[1])
	end

	def random_pick arr
		return nil if arr.length < 1
		picked_idx = rand(arr.length)
		arr[picked_idx]
	end

end