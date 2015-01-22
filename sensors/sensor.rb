class Sensor 	
	def initialize
		@output_wires = []
	end

	def outcome
		raise "method not implemented"
	end

	private
	def add_output_wires(*wires)
		@output_wires += wires
	end

end