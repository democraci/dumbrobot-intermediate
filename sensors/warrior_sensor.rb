require 'sensor'

class WarriorSensor < Sensor
	def initialize(warrior)
		@warrior = warrior
	end

	def outcome
		@warrior
	end
end