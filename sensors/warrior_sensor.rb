require 'singleton'
require File.dirname(__FILE__) + '/../wires/wire'
require File.dirname(__FILE__) + '/sensor'

class WarriorSensor < Sensor
	include Singleton

	Wires.add_sources_to_wire(:warrior, self.instance)

	def set_warrior(warrior)
		@warrior = warrior
	end

	def outcome
		@warrior
	end
end