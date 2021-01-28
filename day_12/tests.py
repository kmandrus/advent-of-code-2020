import rain_risk

start = (0, 0)
route = rain_risk.load_input('input.txt')
calc = rain_risk.ManhattanDistanceCalculator(start, route)

print("part one answer:")
print(calc.compute_manhattan_distance())

print("TESTS")
test_start = (0, 0)
test_route = rain_risk.load_input('test_input.txt')
test_calc = rain_risk.ManhattanDistanceCalculator(start, test_route)
print("#rotate_heading_by")
test_calc.rotate_heading_by('R', 90)
print(test_calc.heading == test_calc.south)
test_calc.rotate_heading_by('L', 360)
print(test_calc.heading == test_calc.south)
test_calc.rotate_heading_by('L', 270)
print(test_calc.heading == test_calc.west)
test_calc.rotate_heading_by('R', 180)
print(test_calc.heading == test_calc.east)

print("#add")
print(test_calc.add((5, 4), (-1, 6)) == (4, 10))
print(test_calc.add((0, 0), (-3, 5)) == (-3, 5))

print('#parse_step')
print(test_calc.parse_step('R180') == ('R', 180))
print(test_calc.parse_step('L90') == ('L', 90))
print(test_calc.parse_step('F5') == ('F', 5))
print(test_calc.parse_step('W20') == ('W', 20))

print("#compute_move_tuple")
print(test_calc.compute_move_tuple('W', 30) == (-30, 0))
print(test_calc.compute_move_tuple('S', 1) == (0, -1))
print(test_calc.compute_move_tuple('N', 109) == (0, 109))
print(test_calc.compute_move_tuple('E', 12) == (12, 0))

print("#move")

print("#travel_route")
print(test_calc.current_pos == (17, -8))

print("#compute_manhattan_distance")
print(test_calc.compute_manhattan_distance() == 25)
