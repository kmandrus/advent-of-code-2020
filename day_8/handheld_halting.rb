class Handheld_Halting
    attr_reader :instructions

    def initialize(filepath)
        @instructions = load_instructions(filepath)
        @log = new_log
        @accumulator = 0
    end

    def part_1_answer
        run
        answer = @accumulator
        reset
        answer
    end

    def part_2_answer
        swap_instruction!(corrupted_index)
        run
        answer = @accumulator
        swap_instruction!(corrupted_index)
        reset
        answer
    end

    def run
        i = 0
        until (i >= instructions.length || @log[i])
            @log[i] = true
            i += execute_instruction(instructions[i])
        end

        return true if i >= instructions.length
        false
    end

    def corrupted_index
        potential_corrupted_indices.each do |i|
            return i if index_corrupted?(i)
        end
        nil
    end

    def potential_corrupted_indices
        run
        candidates = []
        @log.each_with_index do |executed, i|
            cmd = instructions[i].first
            if (executed && (cmd != :acc))
                candidates << i
            end
        end
        reset
        candidates
    end

    def index_corrupted?(index)
        swap_instruction!(index)
        corrupted = false
        corrupted = true if run
        swap_instruction!(index)
        reset
        corrupted
    end

    def swap_instruction!(index)
        cmd = instructions[index][0]
        if cmd == :jmp
            @instructions[index][0] = :nop
        elsif cmd == :nop
            @instructions[index][0] = :jmp
        else
            raise "cannop swap an acc command"
        end
    end

    def load_instructions(filepath)
        File.readlines(filepath, chomp: true)
            .map { |line| format_to_cmd_arg(line) }
    end

    def reset
        @log = new_log
        @accumulator = 0
    end

    def format_to_cmd_arg(str)
        cmd, arg = str.split
        cmd = cmd.to_sym
        arg = arg.to_i
        [cmd, arg]
    end

    def execute_instruction(cmd_arg)
        cmd, arg = cmd_arg
        case cmd
        when :nop
            return 1 
        when :acc
            @accumulator += arg
            return 1
        when :jmp
            return arg
        end
    end

    def new_log
        Array.new(656, false)
    end

end

hh = Handheld_Halting.new('input.txt')
#puts "Answer to Part 1: #{hh.part_1_answer}"
puts "Answer to Part 2: #{hh.part_2_answer}"

#testing
#arr = hh.potential_corrupted_indices
#arr.each { |i| print "#{hh.instructions[i]} \n" }
#puts hh.run