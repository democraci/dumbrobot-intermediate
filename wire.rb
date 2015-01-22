class Wire
	# Wire have 3 parts, input source, output destination, combine function

	def initialize
		@sources = nil
		@destinations = nil
		@combine_func = nil
	end

	def add_source(*sources)
		@sources += sources
	end

	def add_destination(*destinations)
		@destinations += destinations
	end

	def set_combine_func(func)
		@combine_func = func
	end


end