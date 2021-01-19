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

        adapter_ratings
            .unshift(0)
            .push(adapter_ratings.last + 3)
    end

    def jolt_jump_log
        return @jolt_jump_log if @jolt_jump_log
        
        @jolt_jump_log = Hash.new(0)
        prev_jolt_rating = 0
        @adapter_ratings.each do |jolt_rating|
            difference = jolt_rating - prev_jolt_rating
            raise "jolt rating difference is greater than 3" if difference > 3
            @jolt_jump_log[difference] += 1
            prev_jolt_rating = jolt_rating
        end

        @jolt_jump_log
    end

    def part_1_answer
        jolt_jump_log[1] * (jolt_jump_log[3])
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



