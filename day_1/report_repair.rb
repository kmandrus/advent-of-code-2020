require 'byebug'

class Report_Repair
    attr_reader :report, :sorted_report

    def initialize(report_file_path)
        report = File.readlines(report_file_path, chomp: true)
        @report = report.map(&:to_i)
        @sorted_report = merge_sort(@report)
    end

    #nlog(n) time
    def merge_sort(nums)
        if nums.length < 2
            return nums
        end
        mid = nums.length / 2
        first_half = merge_sort(nums[0...mid])
        second_half = merge_sort(nums[(mid)..-1])
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
    #n^2 time
    def naive_two_sum_to_2020
        @report.each_with_index do |num_1, idx_1|
            @report.each_with_index do |num_2, idx_2|
                if idx_2 > idx_1
                    return num_1 * num_2 if num_1 + num_2 == 2020
                end
            end
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
    def three_sum_to(sorted_nums, target)
        sorted_nums.each_with_index do |val, i|
            two_sum_target = target - val
            two_sum_result = two_sum_to(sorted_nums[(i+1)..-1], two_sum_target)
            return two_sum_result + [val] if two_sum_result
        end
        nil
    end
end

report_repair = Report_Repair.new("./input.txt")
nums = report_repair.three_sum_to(report_repair.sorted_report, 2020)
p nums
p nums[0] * nums[1] * nums[2]

#tests
puts "\ntests"
p report_repair.binary_search(report_repair.sorted_report, 769) == 7
p report_repair.binary_search(report_repair.sorted_report, 1994) == 190
p report_repair.binary_search(report_repair.sorted_report, -10) == nil
p report_repair.two_sum_to(report_repair.sorted_report, 1768 + 1995).sum == 1768 + 1995
p report_repair.two_sum_to(report_repair.sorted_report, 451 + 1252).sum == 451 + 1252
p report_repair.two_sum_to(report_repair.sorted_report, -1) == nil
p report_repair.three_sum_to(report_repair.sorted_report, 769 + 1190 + 2008).sum == 769 + 1190 + 2008
