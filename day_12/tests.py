import rain_risk
from rain_risk import WaypointRouteFinder

route = rain_risk.load_input('input.txt')
route_finder = rain_risk.RouteFinder(route)
wp_route_finder = rain_risk.WaypointRouteFinder(route)

print("part one answer:")
print(route_finder.compute_manhattan_distance(
    route_finder.start,
    route_finder.pos
))
print("part two answer:")
print(wp_route_finder.compute_manhattan_distance(
    wp_route_finder.start,
    wp_route_finder.pos
))

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

print("#move_pos")
print(test_route_finder.move_pos((5, 4), (-1, 6)) == (4, 10))
print(test_route_finder.move_pos((0, 0), (-3, 5)) == (-3, 5))

print('#parse_line')
print(rain_risk.parse_line('R180') == ('R', 180))
print(rain_risk.parse_line('L90') == ('L', 90))
print(rain_risk.parse_line('F5') == ('F', 5))
print(rain_risk.parse_line('W20') == ('W', 20))

print("#compute_delta")
print(test_route_finder.compute_delta('W', 30) == (-30, 0))
print(test_route_finder.compute_delta('S', 1) == (0, -1))
print(test_route_finder.compute_delta('N', 109) == (0, 109))
print(test_route_finder.compute_delta('E', 12) == (12, 0))

print("#move")

print("#travel_route")
print(test_route_finder.pos == (17, -8))

print("#compute_manhattan_distance")
test_route_finder = rain_risk.RouteFinder(test_route)
print(test_route_finder.compute_manhattan_distance(
    test_route_finder.start, 
    test_route_finder.pos) == 25)

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

print("#rotate_waypoint_about_origin")
test_wp_route_finder = rain_risk.WaypointRouteFinder([])

test_wp_route_finder.rotate_waypoint_about_origin('R', 360)
print(test_wp_route_finder.waypoint == (10, 1))
test_wp_route_finder.rotate_waypoint_about_origin('L', 360)
print(test_wp_route_finder.waypoint == (10, 1))
test_wp_route_finder.rotate_waypoint_about_origin('R', 90)
print(test_wp_route_finder.waypoint == (1, -10))
test_wp_route_finder.rotate_waypoint_about_origin('L', 180)
print(test_wp_route_finder.waypoint == (-1, 10))

test_wp_route_finder.waypoint = (-3, 0)
test_wp_route_finder.rotate_waypoint_about_origin('R', 360)
print(test_wp_route_finder.waypoint == (-3, 0))
test_wp_route_finder.rotate_waypoint_about_origin('L', 360)
print(test_wp_route_finder.waypoint == (-3, 0))
test_wp_route_finder.rotate_waypoint_about_origin('R', 90)
print(test_wp_route_finder.waypoint == (0, 3))
test_wp_route_finder.rotate_waypoint_about_origin('L', 180)
print(test_wp_route_finder.waypoint == (0, -3))

test_wp_route_finder.waypoint = (0, 0)
test_wp_route_finder.rotate_waypoint_about_origin('R', 90)
print(test_wp_route_finder.waypoint == (0,0))

print("#travel_route")
route = rain_risk.load_input("test_input.txt")
test_wp_rf = rain_risk.WaypointRouteFinder(route)
print(test_wp_rf.pos == (214, -72))
