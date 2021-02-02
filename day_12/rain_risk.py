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
    
    def move_pos(self, pos, delta):
        return (pos[0] + delta[0], pos[1] + delta[1])
    
    def move_delta(self, heading, distance):
        diff = self.diffs_by_heading[heading]
        return (diff[0] * distance, diff[1] * distance)
    
    def subtract_positions(self, minuend, subtrahend):
        return (minuend[0] - subtrahend[0], minuend[1] - subtrahend[1])

    def parse_step(self, str):
        return (str[:1], int(str[1:]))
    
    def to_quarter_turns(self, degrees, direction=right):
        turns = degrees // 90
        if direction == self.left:
            turns *= -1
        return turns

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
            delta = self.move_delta(self.heading, distance)
        else:
            delta = self.move_delta(heading, distance)
        self.pos = self.move_pos(self.pos, delta)
        
    def rotate(self, turn_direction, degrees):
        quarter_turns = self.to_quarter_turns(degrees, turn_direction)
        current_heading_idx = self.headings.index(self.heading)
        new_heading_index = (current_heading_idx + quarter_turns) % 4
        self.heading = self.headings[new_heading_index]

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
            self.pos = self.move_pos(self.pos, self.waypoint)

    def rotate_waypoint_about_origin(self, turn_direction, degrees):
        for _ in range(self.to_quarter_turns(degrees)):
            self.waypoint = self.rotate_about_origin_90_degrees(
                self.waypoint, 
                turn_direction)

    def move_waypoint(self, heading, distance):
        delta = self.move_delta(heading, distance)
        self.waypoint = self.move_pos(self.waypoint, delta)

    def travel_route(self):
        for step in self.route:
            cmd, arg = self.parse_step(step)
            if cmd == self.right or cmd == self.left:
                self.rotate_waypoint_about_origin(cmd, arg)
            elif cmd == self.forward:
                self.move(arg)
            else:
                self.move_waypoint(cmd, arg)
    
    def rotate_about_origin_90_degrees(self, pos, direction):
        x, y = pos
        if direction == self.right:
            return (y, -x)
        else:
            return (-y, x)
