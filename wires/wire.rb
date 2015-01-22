class Wire
	# Wire have 3 parts, input source, output destination, combine function
	def initialize(name = nil)
		@sources = []
		@destinations = []
		@combine_func = nil
		@name = name
		@name ||= object_id.to_s
		@outcome = nil
	end

	def add_sources(*sources)
		@sources += sources
		sources.each { |src| src.send(:add_output_wire, self) }
	end

	def add_destinations(*destinations)
		@destinations += destinations
		destinations.each { |dest| dest.send(:add_input_wire, self) }
	end

	def set_combine_func(func)
		@combine_func = func
	end

	def outcome
		@outcome = combine_input
	end

	private
	def combine_input
		if @sources.length <= 1
			@sources.first
		else
			@sources.inject { |result, source| result = @combine_func.call(result, source.outcome) }
		end
	end
end

class Wires
	def self.add_sources_to_wire(wire_name, *sources)
		wire = find_or_create wire_name
		wire.add_sources(*sources)
	end

	def self.add_destinations_to_wire(wire_name, *destinations)
		wire = find_or_create wire_name
		wire.add_destinations *destinations
	end

	def self.set_combine_func_to_wire(wire_name, combine_func) 
		wire = find_or_create wire_name
		wire.set_combine_func(combine_func)
	end

	def self.find_or_create wire_name
		@name_register ||= {}
		@name_register[wire_name] ||= new(wire_name)
	end
end