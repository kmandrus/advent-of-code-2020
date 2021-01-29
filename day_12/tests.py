import rain_risk
from rain_risk import WaypointRouteFinder

route = rain_risk.load_input('input.txt')
route_finder = rain_risk.RouteFinder(route)
wp_route_finder = rain_risk.WaypointRouteFinder(route)

print("part one answer:")
print(route_finder.compute_manhattan_distance())
print("part two answer:")
print(wp_route_finder.compute_manhattan_distance())

print("-" * 40)
print("TESTS - ROUTE FINDER")
test_route = rain_risk.load_input('test_input.txt')
test_route_finder = rain_risk.RouteFinder(test_route)
print("#rotate")
test_route_finder.heading = test_route_finder.east
test_route_finder.rotate('R', 90)
print(test_route_finder.heading == test_route_finder.south)
test_route_finder.rotate('L', 360)
print(test_route_finder.heading == test_route_finder.south)
test_route_finder.rotate('L', 270)
print(test_route_finder.heading == test_route_finder.west)
test_route_finder.rotate('R', 180)
print(test_route_finder.heading == test_route_finder.east)

print("#add")
print(test_route_finder.add((5, 4), (-1, 6)) == (4, 10))
print(test_route_finder.add((0, 0), (-3, 5)) == (-3, 5))

print('#parse_step')
print(test_route_finder.parse_step('R180') == ('R', 180))
print(test_route_finder.parse_step('L90') == ('L', 90))
print(test_route_finder.parse_step('F5') == ('F', 5))
print(test_route_finder.parse_step('W20') == ('W', 20))

print("#compute_move_tuple")
print(test_route_finder.compute_move_tuple('W', 30) == (-30, 0))
print(test_route_finder.compute_move_tuple('S', 1) == (0, -1))
print(test_route_finder.compute_move_tuple('N', 109) == (0, 109))
print(test_route_finder.compute_move_tuple('E', 12) == (12, 0))

print("#move")

print("#travel_route")
print(test_route_finder.pos == (17, -8))

print("#compute_manhattan_distance")
print(test_route_finder.compute_manhattan_distance() == 25)

print("-" * 40)
print("TESTS - WAYPOINT ROUTE FINDER")

print("#move")
test_wp_route_finder = rain_risk.WaypointRouteFinder([])
test_wp_route_finder.move(2)
print(test_wp_route_finder.pos == (20, 2))
test_wp_route_finder.waypoint = (-20, -5)
test_wp_route_finder.move(1)
print(test_wp_route_finder.pos == (0, -3))

print("#move_waypoint")
test_wp_route_finder = rain_risk.WaypointRouteFinder([])
test_wp_route_finder.move_waypoint('E', 7)
print(test_wp_route_finder.waypoint == (17, 1))
test_wp_route_finder.move_waypoint('W', 30)
print(test_wp_route_finder.waypoint == (-13, 1))
test_wp_route_finder.move_waypoint('S', 7)
print(test_wp_route_finder.waypoint == (-13, -6))
test_wp_route_finder.move_waypoint('N', 3)
print(test_wp_route_finder.waypoint == (-13, -3))

print("#rotate")
test_wp_route_finder = rain_risk.WaypointRouteFinder([])

test_wp_route_finder.rotate('R', 360)
print(test_wp_route_finder.waypoint == (10, 1))
test_wp_route_finder.rotate('L', 360)
print(test_wp_route_finder.waypoint == (10, 1))
test_wp_route_finder.rotate('R', 90)
print(test_wp_route_finder.waypoint == (1, -10))
test_wp_route_finder.rotate('L', 180)
print(test_wp_route_finder.waypoint == (-1, 10))

test_wp_route_finder.waypoint = (-3, 0)
test_wp_route_finder.rotate('R', 360)
print(test_wp_route_finder.waypoint == (-3, 0))
test_wp_route_finder.rotate('L', 360)
print(test_wp_route_finder.waypoint == (-3, 0))
test_wp_route_finder.rotate('R', 90)
print(test_wp_route_finder.waypoint == (0, 3))
test_wp_route_finder.rotate('L', 180)
print(test_wp_route_finder.waypoint == (0, -3))

test_wp_route_finder.waypoint = (0, 0)
test_wp_route_finder.rotate('R', 90)
print(test_wp_route_finder.waypoint == (0,0))

print("#travel_route")
route = rain_risk.load_input("test_input.txt")
test_wp_rf = rain_risk.WaypointRouteFinder(route)
print(test_wp_rf.pos == (214, -72))
