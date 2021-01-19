require "byebug"

class Encoding_Error
    def initialize(filepath)
        @code = load_code(filepath)
    end

    def load_code(filepath)
        File.readlines(filepath, chomp: true)
            .map { |str| str.to_i }
    end

    def contiguous_sum_to_targert(target)
        @code.each_with_index do |start_num, start_i| 
            sum = start_num
            (start_i+1..@code.length).each do |end_i|
                if sum == target
                    return @code[start_i...end_i]
                elsif sum > target
                    break
                end

                next_num = @code[end_i]
                sum += next_num
            end
        end
        nil
    end

    def first_invalid_number
        i = 25
        #debugger
        while (valid?(i) && i < @code.length)
            i += 1
        end
        return nil if i == @code.length
        @code[i]
    end

    def valid?(i)
        raise "#{i} in preamble" if in_initial_preamble?(i)
        
        preamble = @code[i-25...i].sort { |a, b| b <=> a }
        target = @code[i]

        preamble.each_with_index do |big_num, j|
            if sum_to_target?(target, big_num, preamble[j+1..-1].reverse)
                return true
            end
        end
        false
    end

    def sum_to_target?(target, big_num, candidates_least_to_greatest)
        candidates_least_to_greatest.each do |small_num|
            sum = big_num + small_num
            if sum > target
                return false
            elsif sum == target
                return true
            end
        end
        false
    end

    def in_initial_preamble?(i)
        i < 25
    end
end

ee = Encoding_Error.new("input.txt")
invalid_number = ee.first_invalid_number
puts invalid_number
puts
nums = ee.contiguous_sum_to_targert(invalid_number).sort
puts nums.first + nums.last
