require File.dirname(__FILE__) + '/../payload/moves_options.rb'

class Wire
	# Wire have 3 parts, input source, output destination, combine function
	attr_reader :sources, :destinations, :name

	def initialize(name)
		@sources = []
		@destinations = []
		@combine_func = nil
		@name = name
		@name ||= object_id.to_s
		@outcome = nil
	end

	def add_sources(*sources)
		@sources += sources
		sources.each { |src| src.send(:add_output_wires, self) }
	end

	def add_destinations(*destinations)
		@destinations += destinations
		destinations.each { |dest| dest.send(:add_input_wires, self) }
	end

	def set_combine_func(func)
		@combine_func = func
	end

	def outcome
		@outcome = combine_input
	end

  # there are two kinds of wire allowed in our control system
  #  1. associated with many input sources, one destination
  #  2. associated with many output destinations, one input source
  # those wires which not applied to this regulation is illegal
	def legal?
		(@sources.length == 1 and @destinations.length >= 1) || (@sources.length >= 1 and @destinations.length == 1)
	end

	private
	def combine_input
		if @sources.length <= 1
			@sources.first
		else
			@sources.map(&:outcome).inject { |result, outcome| @combine_func.call(result.outcome, source.outcome) }
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
		@name_register[wire_name] ||= Wire.new(wire_name)
	end
end

ALL_WIRES = [:command, :warrior]

Wires.set_combine_func_to_wire(:command, MovesOptions.method(:combine))
Wires.set_combine_func_to_wire(:warrior, lambda do |a, b| a end)

