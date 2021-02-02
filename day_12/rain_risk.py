#Headings are tuples: N = (0, 1), S = (0, -1), E = (1, 0), W = (-1, 0)
#When given a F60 command, we multiply the values in the heading by 60, 
#then add that value to the tuple containing our current position.

#Current Position is represented as a tuple (x, y).

#Moving in a direction, like N30, we pull the North tuple from the list,
#multiply each value by 30, then add the resulting tuple to our current 
#location.

def load_input(filepath):
    with open(filepath) as file:
        return file.readlines() 

class OceanTravelMixin:
    north, south, east, west, forward = 'N', 'S', 'E', 'W', 'F'
    right, left = 'R', 'L'
    headings = [north, east, south, west]
    diffs_by_heading = {
        north: (0, 1), 
        south: (0, -1), 
        east: (1, 0), 
        west: (-1, 0)
    }

    def compute_manhattan_distance(self, start, end):
        delta_x, delta_y = self.subtract_positions(start, end)
        return abs(delta_x) + abs(delta_y)
    
    def add_positions(self, pos_1, pos_2):
        return (pos_1[0] + pos_2[0], pos_1[1] + pos_2[1])
    
    def subtract_positions(self, minuend, subtrahend):
        return (minuend[0] - subtrahend[0], minuend[1] - subtrahend[1])

    def parse_step(self, str):
        return (str[:1], int(str[1:]))
    
    def compute_move_tuple(self, heading, distance):
        diff = self.diffs_by_heading[heading]
        return (diff[0] * distance, diff[1] * distance)

class RouteFinder(OceanTravelMixin):
    
    def __init__(self, route):
        self.start = (0, 0)
        self.route = route
        self.heading = self.east
        self.pos = self.start
        self.travel_route()

    def travel_route(self):
        for step in self.route:
            cmd, arg = self.parse_step(step)
            if cmd == self.right or cmd == self.left:
                self.rotate(cmd, arg)
            else:
                self.move(cmd, arg)
    
    def move(self, heading, distance):
        if heading == self.forward:
            move_tuple = self.compute_move_tuple(self.heading, distance)
        else:
            move_tuple = self.compute_move_tuple(heading, distance)
        self.pos = self.add_positions(self.pos, move_tuple)

    def rotate(self, turn_direction, degrees):
        quarter_turns = degrees // 90
        if turn_direction == self.left:
            quarter_turns *= -1
        heading_idx = self.headings.index(self.heading)
        self.heading = self.headings[(heading_idx + quarter_turns) % 4]

class WaypointRouteFinder(OceanTravelMixin):
    rotation_diffs_by_axis = { 0:(1,0), 1:(0,1), 2:(-1,0), 3:(0,-1) }

    def __init__(self, route, waypoint=(10, 1)):
        self.waypoint = waypoint
        self.route = route
        self.start = (0,0)
        self.pos = self.start
        self.travel_route()
    
    def move(self, times):
        for i in range(times):
            self.pos = self.add_positions(self.pos, self.waypoint)

    def rotate_waypoint_around_origin(self, turn_direction, degrees):
        num_turns = degrees // 90
        new_waypoint = self.waypoint
        for _ in range(num_turns):
            if turn_direction == self.right:
                new_waypoint = self.rotate_pos_around_origin_90deg_right(
                    new_waypoint)
            else:
                new_waypoint = self.rotate_pos_around_origin_90deg_left(
                    new_waypoint)
        self.waypoint = new_waypoint
    
    def move_waypoint(self, heading, distance):
        move_tuple = self.compute_move_tuple(heading, distance)
        self.waypoint = self.add_positions(self.waypoint, move_tuple)

    def travel_route(self):
        for step in self.route:
            cmd, arg = self.parse_step(step)
            if cmd == self.right or cmd == self.left:
                self.rotate_waypoint_around_origin(cmd, arg)
            elif cmd == self.forward:
                self.move(arg)
            else:
                self.move_waypoint(cmd, arg)
    
    def rotate_pos_around_origin_90deg_right(self, pos):
        x, y = pos
        return (y, -x)
    
    def rotate_pos_around_origin_90deg_left(self, pos):
        x, y = pos
        return (-y, x)
