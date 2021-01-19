class Binary_Boarding
    def initialize(filepath)
        @seat_assignments = load_boarding_passes(filepath)
    end

    def load_boarding_passes(filepath)
        seat_assignments = Array.new(128) { Array.new(8, 0) }
        file = File.readlines(filepath).each do |line|
            row_str, col_str = line[0..6], col_str = line[7..9]
            row_num = str_to_row_num(row_str)
            col_num = str_to_col_num(col_str)
            seat_assignments[row_num][col_num] = seat_id(row_num, col_num)
        end
        seat_assignments
    end

    def highest_seat_id
        @seat_assignments.flatten.max
    end

    def str_to_row_num(str)
        min, max = 1, 128 
        str.each_char do |char|
            if char == 'F'
                max = (min + max) / 2
            elsif char == 'B'
                min = ( (min + max) / 2) + 1
            end
        end
        max - 1
    end

    def str_to_col_num(str)
        min, max = 1, 8 
        str.each_char do |char|
            if char == 'L'
                max = (min + max) / 2
            elsif char == 'R'
                min = ( (min + max) / 2) + 1
            end
        end
        max - 1
    end

    def seat_id(row, col)
        row * 8 + col
    end

    def print_seat_assignments
        @seat_assignments.each do |row|
            print row
            puts
        end
    end

    def empty_seat_id
        missing_seats = true
        @seat_assignments.each_with_index do |row, row_num|
            row.each_with_index do |seat, col_num|
                if missing_seats && seat != 0
                    missing_seats = false
                elsif !missing_seats && seat.zero?
                    return seat_id(row_num, col_num)
                end
            end
        end
    end
    
end

bb = Binary_Boarding.new("input.txt")
#bb.print_seat_assignments
#puts bb.highest_seat_id
puts bb.empty_seat_id