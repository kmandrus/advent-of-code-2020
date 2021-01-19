require "byebug"

class Adapter_Array
    attr_reader :adapters

    def initialize(filepath)
        @adapter_ratings = load_adapter_ratings(filepath)
        @num_adapter_combos_for_rating = { 0 => 1 }
    end

    def load_adapter_ratings(filepath)
        adapter_ratings = File.readlines(filepath, chomp: true)
            .map(&:to_i)
            .sort
        add_charger_and_device_ratings!(adapter_ratings)
    end

    def add_charger_and_device_ratings!(adapter_ratings)
        adapter_ratings
            .unshift(0)
            .push(adapter_ratings.last + 3)
    end

    def jolt_jump_count
        return @jolt_jump_count if @jolt_jump_count
        
        @jolt_jump_count = Hash.new(0)
        (0...@adapter_ratings.length).each do |i|
            count_jolt_difference!(@jolt_jump_count, i)
        end
        @jolt_jump_count
    end

    def count_jolt_difference!(count, adapter_rating_index)
        return count if adapter_rating_index.zero?
        jolt_rating = @adapter_ratings[adapter_rating_index]
        prev_jolt_rating = @adapter_ratings[adapter_rating_index - 1]
        difference = jolt_rating - prev_jolt_rating
        count[difference] += 1
    end

    def part_1_answer
        jolt_jump_count[1] * jolt_jump_count[3]
    end

    def part_2_answer
        answer = @num_adapter_combos_for_rating[@adapter_ratings.last]
        return answer if answer 

        ratings = @adapter_ratings
        ratings.each_with_index do |rating, i|
            connections = valid_connections(i)
            sum = connections
                .sum do |connection|
                    @num_adapter_combos_for_rating[connection]
                end
            @num_adapter_combos_for_rating[rating] = sum unless rating.zero?
        end
        @num_adapter_combos_for_rating[@adapter_ratings.last]
    end

    def valid_connections(adapter_ratings_index)
        i = adapter_ratings_index - 1
        connections = []
        return connections if i < 0
        until @adapter_ratings[i] + 3 < @adapter_ratings[adapter_ratings_index] || i < 0
            connections << @adapter_ratings[i]
            i -= 1
        end
        connections
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



