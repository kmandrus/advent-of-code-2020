class WaitingArea:
    diffs = [(1, 0), (1, 1), (1, -1), (0, 1), (0, -1), (-1, 0), (-1, -1), (-1, 1)]
    emptySeat = 'L'
    occupiedSeat = '#'
    floor = '.'
             
    def __init__(self, area):
        self.area = area
        self.width = len(self.area[0])
        self.height = len(self.area)
    
    def findStableState(self):
        states = [self, self.nextAreaState()]
        while states[-1].isDifferentFrom(states[-2]):
            states.append(states[-1].nextAreaState())
        return states[-1]

    def nextAreaState(self):
        pass
    
    def nextSeatState(self, pos):
        pass

    def firstSeatAlongDiff(self, start, diff):
        nextPos = self.applyDiff(start, diff)
        while self.isInArea(nextPos) and self.seatAt(nextPos) == self.floor:
            nextPos = self.applyDiff(nextPos, diff)
        if not self.isInArea(nextPos):
            return None
        else:
            return self.seatAt(nextPos)
    
    def isDifferentFrom(self, otherArea):
        for row_num, row in enumerate(self.area):
            otherRow = otherArea.area[row_num]
            for col_num, seat in enumerate(row):
                otherSeat = otherRow[col_num]
                if seat != otherSeat:
                    return True
        return False
    
    def countOccupiedSeats(self):
        count = 0
        for row in self.area:
            for seat in row:
                if seat == self.occupiedSeat:
                    count += 1
        return count

    def seatAt(self, pos):
        row, col = pos
        return self.area[row][col]

    def isInArea(self, pos):
        row, col = pos
        return (col >= 0 and row >= 0 and row < self.height and col < self.width)
    
    def applyDiff(self, pos, diff):
        return (pos[0] + diff[0], pos[1] + diff[1])

    def print(self):
        for row in self.area:
            for seat in row:
                print(seat, end='')
            print('')

class AdjacentRuleWaitingArea(WaitingArea):

    def nextAreaState(self):
        nextState = []
        for row_num, row in enumerate(self.area):
            newRow = []
            for col_num in range(len(row)):
                pos = (row_num, col_num)
                newRow.append(self.nextSeatState(pos))
            nextState.append(newRow)
            newRow = []
        return AdjacentRuleWaitingArea(nextState)

    def nextSeatState(self, pos):
        occupiedSeats = self.adjacentSeats(pos).count(self.occupiedSeat)
        seat = self.seatAt(pos)
        if seat == self.floor:
            return self.floor
        elif occupiedSeats == 0:
            return self.occupiedSeat
        elif occupiedSeats >= 4:
            return self.emptySeat
        else:
            return seat

    def adjacentSeats(self, pos):
        seats = []
        for diff in self.diffs:
            adjPos = self.applyDiff(pos, diff)
            if self.isInArea(adjPos):
                seats.append(self.seatAt(adjPos))
        return seats

class VisibleRuleWaitingArea(WaitingArea):

    def nextAreaState(self):
        nextState = []
        for row_num, row in enumerate(self.area):
            newRow = []
            for col_num in range(len(row)):
                pos = (row_num, col_num)
                newRow.append(self.nextSeatState(pos))
            nextState.append(newRow)
            newRow = []
        return VisibleRuleWaitingArea(nextState)
    
    def nextSeatState(self, pos):
        occupiedSeats = self.visibleSeats(pos).count(self.occupiedSeat)
        originalSeat = self.seatAt(pos)
        if originalSeat == self.floor:
            return self.floor
        elif occupiedSeats == 0:
            return self.occupiedSeat
        elif occupiedSeats >= 5:
            return self.emptySeat
        else:
            return originalSeat

    def visibleSeats(self, pos):
        seats = []
        for diff in self.diffs:
            seat = self.firstSeatAlongDiff(pos, diff)
            if seat:
                seats.append(seat)
        return seats

def loadAreaDataFromFile(filepath):
    with open(filepath) as file:
        waitingArea, row = [], []
        for line in file:
            for char in line:
                if char != "\n":
                    row.append(char)
            waitingArea.append(row)
            row = []
        return waitingArea
