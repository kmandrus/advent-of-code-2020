require "byebug"

class Adapter_Array
    attr_reader :adapters

    def initialize(filepath)
        @adapters = load_adapters(filepath)
    end

    def load_adapters(filepath)
        File.readlines(filepath, chomp: true)
            .map(&:to_i)
            .sort
    end

    def jolt_jump_log
        return @jolt_jump_log if @jolt_jump_log
        
        @jolt_jump_log = Hash.new(0)
        prev_jolt_rating = 0
        @adapters.each do |jolt_rating|
            difference = jolt_rating - prev_jolt_rating
            raise "jolt rating difference is greater than 3" if difference > 3
            @jolt_jump_log[difference] += 1
            prev_jolt_rating = jolt_rating
        end

        @jolt_jump_log
    end

    def part_1_answer
        jolt_jump_log[1] * (jolt_jump_log[3] + 1)
    end

    def part_2_answer
        @adapters.unshift(0)
        @adapter_arrangements = {}
        @adapters.each_with_index do |rating, i|
            #put into helpter or think of something better
            bot = i - 3
            bot = 0 if bot < 0 
            #another helper probably
            connections = @adapters[bot...i]
                .select { |connection| connection + 3 >= rating }
            sum = connections
                .sum { |connection| @adapter_arrangements[connection] }
            if rating == 0
                @adapter_arrangements[rating] = 1
            else
                @adapter_arrangements[rating] = sum
            end
        end
        @adapter_arrangements[@adapters.last]
    end


end

aa = Adapter_Array.new("input.txt")
puts aa.part_1_answer
puts aa.part_2_answer

#testing
# test_aa = Adapter_Array.new("test_input.txt")
# puts test_aa.part_2_answer == 7



