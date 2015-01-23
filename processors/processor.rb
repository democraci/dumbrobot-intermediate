class Processor
	attr_reader :outcome
	attr_reader :output_wires

	def initialize
		@input_wires = []
		@output_wires = []
		@outcome = nil
	end
	# a processor have 3 parts
	def process	
	end

	def find_input_wire(name)
		@input_wires.detect {|wire| wire.name == name }
	end

	private
	def add_input_wires(*wires)
		@input_wires += wires
	end

	def add_output_wires(*wires)
		@output_wires += wires
	end
end