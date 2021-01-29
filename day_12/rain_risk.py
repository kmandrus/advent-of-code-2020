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

class RouteFinder:
    north, south, east, west, forward = 'N', 'S', 'E', 'W', 'F'
    right, left = 'R', 'L'
    headings = [north, east, south, west]
    diffs_by_heading = { north:(0, 1), south:(0, -1), east:(1,0), west:(-1,0) }
    
    def __init__(self, route):
        self.start = (0, 0)
        self.route = route
        self.heading = self.east
        self.pos = self.start
        self.travel_route()
    
    def compute_manhattan_distance(self):
        delta_x = abs(self.pos[0] - self.start[0])
        delta_y = abs(self.pos[1] - self.start[1])
        return delta_x + delta_y

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
        self.pos = self.add(self.pos, move_tuple)

    def rotate(self, turn_direction, degrees):
        turn_amount = degrees // 90
        if turn_direction == self.left:
            turn_amount *= -1
        heading_idx = self.headings.index(self.heading)
        self.heading = self.headings[(heading_idx + turn_amount) % 4]
    
    def compute_move_tuple(self, heading, distance):
        diff = self.diffs_by_heading[heading]
        return (diff[0] * distance, diff[1] * distance)
    
    def add(self, pos_1, pos_2):
        return (pos_1[0] + pos_2[0], pos_1[1] + pos_2[1])

    def parse_step(self, str):
        return (str[:1], int(str[1:]))

class WaypointRouteFinder(RouteFinder):
    rotation_diffs_by_axis = { 0:(1,0), 1:(0,1), 2:(-1,0), 3:(0,-1) }

    def __init__(self, route, waypoint=(10, 1)):
        self.waypoint = waypoint
        super().__init__(route)
    
    def move(self, times):
        for i in range(times):
            self.pos = self.add(self.pos, self.waypoint)

    def rotate(self, turn_direction, degrees):
        num_turns = degrees // 90
        new_waypoint = self.waypoint
        for _ in range(num_turns):
            if turn_direction == self.right:
                new_waypoint = self.rotate_right_quarter_turn(new_waypoint)
            else:
                new_waypoint = self.rotate_left_quarter_turn(new_waypoint)
        self.waypoint = new_waypoint
    
    def move_waypoint(self, heading, distance):
        move_tuple = self.compute_move_tuple(heading, distance)
        self.waypoint = self.add(self.waypoint, move_tuple)

    def travel_route(self):
        for step in self.route:
            cmd, arg = self.parse_step(step)
            if cmd == self.right or cmd == self.left:
                self.rotate(cmd, arg)
            elif cmd == self.forward:
                self.move(arg)
            else:
                self.move_waypoint(cmd, arg)
    
    def rotate_right_quarter_turn(self, pos):
        x, y = pos
        return (y, -x)
    
    def rotate_left_quarter_turn(self, pos):
        x, y = pos
        return (-y, x)
