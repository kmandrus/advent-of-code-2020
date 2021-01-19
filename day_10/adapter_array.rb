require "byebug"

class Adapter_Array
    attr_reader :adapters

    def initialize(filepath)
        @adapters = load_adapter_ratings(filepath)
    end

    def part_1_answer
        jolt_jump_count[1] * jolt_jump_count[3]
    end

    def jolt_jump_count
        return @jolt_jump_count if @jolt_jump_count
        
        @jolt_jump_count = Hash.new(0)
        (0...adapters.length).each do |i|
            count_jolt_difference!(@jolt_jump_count, i)
        end
        @jolt_jump_count
    end

    def count_jolt_difference!(count, adapter_rating_index)
        return count if adapter_rating_index.zero?
        jolt_rating = @adapters[adapter_rating_index]
        prev_jolt_rating = @adapters[adapter_rating_index - 1]
        difference = jolt_rating - prev_jolt_rating
        count[difference] += 1
    end

    def part_2_answer
        ways_to_reach_charger(@adapters.last)
    end

    def ways_to_reach_charger(adapter)
        @ways_to_reach_charger = { 0 => 1 } unless @ways_to_reach_charger
        ways = @ways_to_reach_charger[adapter]
        return ways if ways
        
        connections = valid_connections(adapter)
        ways = connections.sum do |connection| 
            ways_to_reach_charger(connection)
        end
        @ways_to_reach_charger[adapter] = ways 
    end

    def valid_connections(adapter)
        adapter_index = to_index(adapter)
        return [] if (adapter_index - 1).negative?
        
        lower_slice_index = adapter_index - 3
        lower_slice_index = 0 if lower_slice_index.negative?
        potential_connection_indices = (lower_slice_index...adapter_index)

        @adapters[potential_connection_indices]
            .select { |connection| connection + 3 >= adapter }
    end

    def load_adapter_ratings(filepath)
        adapters = File.readlines(filepath, chomp: true)
            .map(&:to_i)
            .sort
        add_charger_and_device!(adapters)
    end

    def add_charger_and_device!(adapters)
        adapters
            .unshift(0)
            .push(adapters.last + 3)
    end

    def to_index(adapter)
        return @adapter_to_index_hash[adapter] if @adapter_to_index_hash

        @adapter_to_index_hash = Hash.new
        @adapters.each_with_index do |an_adapter, i|
            @adapter_to_index_hash[an_adapter] = i
        end
        @adapter_to_index_hash[adapter]
    end

    def is_charger?(adapter)
        adapter.zero?
    end

end

aa = Adapter_Array.new("input.txt")
puts aa.part_1_answer
puts aa.part_2_answer

#testing
test_aa = Adapter_Array.new("test_input.txt")
puts test_aa.part_2_answer == 7
puts aa.part_1_answer == 2380
puts aa.part_2_answer == 48358655787008



