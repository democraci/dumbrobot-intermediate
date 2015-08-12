# Store data about env
class History
  class << self
    def first_round?
      move_history.empty?
    end

    def move_history
      @move_history ||= []
    end

    def health_history
      @health_history ||= []
    end

    def enemy_locations
      @enemy_locations ||= Set.new
    end

    def max_health
      @max_health
    end

    def last_round_health
      raise "This is first round!" if is_first_round?

      health_history.last
    end

    def last_round_move
      raise "This is first round!" if is_first_round?
      move_history.last
    end

    def update_history(warrior, move)
      if first_round?
        @max_health = warrior.health
      end

      health_history << warrior.health
      move_history << move

    end
  end

end