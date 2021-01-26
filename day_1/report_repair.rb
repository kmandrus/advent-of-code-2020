require 'byebug'

class ReportRepair
    attr_reader :report

    def initialize(report)
        @report = merge_sort(report)
    end

    def product_of_three_entries_that_add_to(num)
        entries = three_sum_to(@report, num)
        entries[0] * entries[1] * entries[2]
    end

    def product_of_two_entries_that_add_to(num)
        entries = two_sum_to(@report, num)
        entries.first * entries.last
    end

    def three_sum_to(sorted_nums, target)
        sorted_nums.each_with_index do |val, i|
            two_sum_target = target - val
            two_sum_result = two_sum_to(sorted_nums[(i+1)..-1], two_sum_target)
            return two_sum_result + [val] if two_sum_result
        end
        nil
    end

    def two_sum_to(sorted_nums, target)
        return nil if sorted_nums.empty?

        nums = sorted_nums.dup
        current = nums.pop
        diff = target - current

        unless diff > sorted_nums.last || diff < sorted_nums.first
            return [current, diff] if binary_search(nums, diff)
        end

        two_sum_to(nums, target)
    end

    #nlog(n) time
    def merge_sort(nums)
        if nums.length <= 1
            return nums
        end
        mid = nums.length / 2
        first_half = merge_sort(nums[0...mid])
        second_half = merge_sort(nums[mid..-1])
        sorted = Array.new

        idx_1, idx_2 = 0, 0
        while idx_1 < first_half.length && idx_2 < second_half.length
            item_1, item_2 = first_half[idx_1], second_half[idx_2]
            if item_1 < item_2 
                sorted << item_1
                idx_1 += 1
            else
                sorted << item_2
                idx_2 += 1
            end
        end
        if idx_1 < first_half.length
            sorted = sorted + first_half[idx_1..-1]
        else
            sorted = sorted + second_half[idx_2..-1]
        end
        sorted
    end

    def binary_search(sorted_nums, target)
        return nil if sorted_nums.empty?
        mid = sorted_nums.length / 2
        mid_val = sorted_nums[mid]

        if mid_val == target
            return mid
        elsif mid_val > target
            return binary_search(sorted_nums[0...mid], target)
        else
            upper_half_idx = binary_search(sorted_nums[(mid+1)..-1], target)
            if upper_half_idx
                return mid + 1 + upper_half_idx
            else
                return nil
            end
        end
    end
end


