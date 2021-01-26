require_relative "report_repair.rb"

def load_report_from_file(filepath)
    File.readlines(filepath, chomp: true)
        .map(&:to_i)
end

report = load_report_from_file('input.txt')
report_repair = Report_Repair.new(report)
nums = report_repair.three_sum_to(report_repair.sorted_report, 2020)
p nums
p nums[0] * nums[1] * nums[2]

#tests
puts "\nTESTS"
p report_repair.binary_search(report_repair.sorted_report, 769) == 7
p report_repair.binary_search(report_repair.sorted_report, 1994) == 190
p report_repair.binary_search(report_repair.sorted_report, -10) == nil
p report_repair.two_sum_to(report_repair.sorted_report, 1768 + 1995).sum == 1768 + 1995
p report_repair.two_sum_to(report_repair.sorted_report, 451 + 1252).sum == 451 + 1252
p report_repair.two_sum_to(report_repair.sorted_report, -1) == nil
p report_repair.three_sum_to(report_repair.sorted_report, 769 + 1190 + 2008).sum == 769 + 1190 + 2008