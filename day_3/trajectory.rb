require "byebug"

class Trajectory
    attr_reader :map

    def initialize(filepath)
        @map = load_map(filepath)
        @map_width = @map.first.length
    end

    def load_map(filepath)
        rows = File.readlines(filepath, chomp: true)
        @map = rows.map { |row| row.split('') }
    end

    def calc_trajectory(start_pos, column_diff, row_diff)
        positions = []
        current_position = start_pos.dup
        while current_position[0] < @map.length
            positions << current_position.dup
            current_position[0] += column_diff
            current_position[1] = (current_position[1] + row_diff) % @map_width
        end
        positions
    end

    def tree?(pos)
        @map[pos.first][pos.last] == '#'
    end

    def compute_collisions(start_pos, column_diff, row_diff)
        positions = calc_trajectory(start_pos, column_diff, row_diff)
        positions.inject(0) do |count, pos| 
            count += 1 if tree?(pos) 
            count
        end
    end

    def part_2_computation(slopes)
        result = slopes.inject([]) do |collision_count, slope|
            collision_count << compute_collisions([0,0], slope.first, slope.last)
        end
        result.inject(:*)
    end

end

trajectory = Trajectory.new("input.txt")
p trajectory.compute_collisions([0,0], 1, 3)
p trajectory.part_2_computation([[1,1], [1,3], [1,5], [1,7], [2,1]])
#p trajectory.calc_trajectory([0,0], 1, 2)
#p trajectory.tree?([0,0]) == false
#p trajectory.tree?([1,2]) == true