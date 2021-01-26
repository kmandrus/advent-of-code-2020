require_relative "report_repair.rb"

def load_report_from_file(filepath)
    File.readlines(filepath, chomp: true)
        .map(&:to_i)
end

report = load_report_from_file('input.txt')
report_repair = ReportRepair.new(report)
print("\nThe product of two entries that add to 2020: ")
puts(report_repair.product_of_two_entries_that_add_to(2020))
print("The product of three entries that add to 2020: ")
puts(report_repair.product_of_three_entries_that_add_to(2020))

#tests
puts "\nTESTS"
p report_repair.binary_search(report_repair.report, 769) == 7
p report_repair.binary_search(report_repair.report, 1994) == 190
p report_repair.binary_search(report_repair.report, -10) == nil
p report_repair.two_sum_to(report_repair.report, 1768 + 1995).sum == 1768 + 1995
p report_repair.two_sum_to(report_repair.report, 451 + 1252).sum == 451 + 1252
p report_repair.two_sum_to(report_repair.report, -1) == nil
p report_repair.three_sum_to(report_repair.report, 769 + 1190 + 2008).sum == 769 + 1190 + 2008
p report_repair.product_of_two_entries_that_add_to(2020) == 357504
p report_repair.product_of_three_entries_that_add_to(2020) == 12747392