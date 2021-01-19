class Custom_Customs
    attr_reader :groups

    def initialize(filepath)
        @groups = load_data_by_group(filepath)
    end

    def load_data_by_sum(filepath)
        sums = []
        group_answers = Hash.new(false)
        File.readlines(filepath, chomp: true).each do |line|
            if line.length.zero?
                sums << group_answers.length
                group_answers = Hash.new(false)
            else
                toggle_answers!(group_answers, line)
            end
        end
       sums << group_answers.length 
    end

    def part_2_answer
        sums = []
        @groups.each do |group|
            count = make_answer_count(group)
            sums << compute_all_yes(count, group.size)
        end
        sums.sum 
    end

    def load_data_by_group(filepath)
        groups, group = [], []
        File.readlines(filepath, chomp: true).each do |line|
            if line.length.zero?
                groups << group
                group = []
            else
                group << line
            end
        end
        groups << group
        groups
    end

    def make_answer_count(group)
        answer_count = Hash.new(0)
        group.each do |answers| 
            add_answers_to_count!(answer_count, answers) 
        end
        answer_count
    end

    def add_answers_to_count!(count, answers)
        answers.each_char { |char| count[char] += 1}
    end

    def compute_all_yes(count, group_size)
        all_yes_count = 0
        count.each_value do |num_yes|
            all_yes_count += 1 if num_yes == group_size
        end
        all_yes_count
    end

    def toggle_answers!(group_answers, individual_answers)
        individual_answers.each_char { |char| group_answers[char] = true }
    end

    def total_of_sums
        @sums.sum
    end
end


cc = Custom_Customs.new("input.txt")
p cc.part_2_answer