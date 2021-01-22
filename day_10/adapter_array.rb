require "byebug"

class Adapter_Array
    attr_reader :adapters

    def initialize(filepath)
        @adapters = load_adapter_ratings(filepath)
    end

    def load_adapter_ratings(filepath)
        adapters = File.readlines(filepath, chomp: true)
            .map(&:to_i)
            .sort
        add_charger_and_device(adapters)
    end

    def add_charger_and_device(adapters)
        adapters.dup
            .unshift(0)
            .push(adapters.last + 3)
    end

    def part_1_answer
        jolt_differences[1] * jolt_differences[3]
    end

    def jolt_differences
        return @count if @count

        @count = Hash.new(0)
        @adapters.each_with_index do |adapter, i|
            next if is_charger?(adapter)
            prev_adapter = @adapters[i-1]
            @count[adapter - prev_adapter] += 1
        end
        @count
    end

    def part_2_answer
        ways_to_reach_charger(@adapters.last)
    end

    def ways_to_reach_charger(adapter)
        @memorized_ways = { 0 => 1 } unless @memorized_ways
        return @memorized_ways[adapter] if @memorized_ways[adapter]
        
        @memorized_ways[adapter] = lower_jolt_connections(adapter)
            .sum { |connection| ways_to_reach_charger(connection) }
    end

    def lower_jolt_connections(adapter)
        return [] if is_charger?(adapter)

        connections = []
        i = (to_index(adapter) - 1)
        connection = @adapters[i]
        while can_connect?(adapter, connection) && i >= 0
            connections << connection
            i -= 1
            connection = @adapters[i]
        end
        connections
    end

    def can_connect?(adapter_1, adapter_2)
        (adapter_1 - adapter_2).abs <= 3
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



