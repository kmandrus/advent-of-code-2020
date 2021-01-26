def loadWaitingArea(filepath):
    with open(filepath) as file:
        waitingArea, row = [], []
        for line in file:
            for char in line:
                if char != "\n":
                    row.append(char)
            waitingArea.append(row)
            row = []
        return waitingArea

emptyArea = loadWaitingArea('input.txt')

def printArea(area):
    for row in area:
        for seat in row:
            print(seat, end='')
        print('')


diffs = [(1, 0), (1, 1), (1, -1), (0, 1), (0, -1), (-1, 0), (-1, -1), (-1, 1)]

def emptySeat():
    return 'L'

def occupiedSeat():
    return '#'

def floor():
    return '.'

def isInArea(pos):
    row, col = pos
    width = len(emptyArea[0])
    height = len(emptyArea)
    return (col >= 0 and row >= 0 and row < height and col < width)

def adjacentSeats(pos, area):
    seats = []
    for diff in diffs:
        pos = applyDiff(pos, diff)
        if isInArea(pos):
            seats.append(area[pos[0]][pos[1]])
    return seats

def seatAt(pos, area):
    row, col = pos
    return area[row][col]

def applyDiff(pos, diff):
    return (pos[0] + diff[0], pos[1] + diff[1])

def firstSeatAlongDiff(start, diff, area):
    nextPos = applyDiff(start, diff)
    while isInArea(nextPos) and seatAt(nextPos, area) == floor():
        nextPos = applyDiff(nextPos, diff)
    if not isInArea(nextPos):
        return None
    else:
        return seatAt(nextPos, area)

def visibleSeats(pos, area):
    seats = []
    for diff in diffs:
        seat = firstSeatAlongDiff(pos, diff, area)
        if seat:
            seats.append(seat)
    return seats

def newSeatState(seat, adjSeats):
    occupiedSeats = adjSeats.count(occupiedSeat())
    if seat == floor():
        return floor()
    elif occupiedSeats == 0:
        return occupiedSeat()
    elif occupiedSeats >= 4:
        return emptySeat()
    else:
        return seat

def newSeatUsingVisible(originalSeat, visibleSeats):
    occupiedSeats = visibleSeats.count(occupiedSeat())
    if originalSeat == floor():
        return floor()
    elif occupiedSeats == 0:
        return occupiedSeat()
    elif occupiedSeats >= 5:
        return emptySeat()
    else:
        return originalSeat

def nextStateUsingAdjacentSeats(area):
    nextState = []
    for row_num, row in enumerate(area):
        newRow = []
        for seat_num, seat in enumerate(row):
            adjSeats = adjacentSeats((row_num, seat_num), area)
            newSeat = newSeatState(seat, adjSeats)
            newRow.append(newSeat)
        nextState.append(newRow)
        newRow = []
    return nextState

def nextStateUsingVisibleSeats(area):
    nextState = []
    for row_num, row in enumerate(area):
        newRow = []
        for seat_num, seat in enumerate(row):
            visible = visibleSeats((row_num, seat_num), area)
            newSeat = newSeatUsingVisible(seat, visible)
            newRow.append(newSeat)
        nextState.append(newRow)
        newRow = []
    return nextState

def countDifferences(area1, area2):
    count = 0
    for row_num, row in enumerate(area1):
        otherRow = area2[row_num]
        for col_num, seat in enumerate(row):
            otherSeat = otherRow[col_num]
            if seat != otherSeat:
                count += 1
    return count

def countOccupiedSeats(area):
    count = 0
    for row in area:
        for seat in row:
            if seat == occupiedSeat():
                count += 1
    return count


#Output
states = [emptyArea, nextStateUsingAdjacentSeats(emptyArea)]
while countDifferences(states[-1], states[-2]) > 0:
    states.append(nextStateUsingAdjacentSeats(states[-1]))
printArea(states[-1])
print(f"number of states: {len(states)}")
print(f"seats occupied: {countOccupiedSeats(states[-1])}")

states = [emptyArea, nextStateUsingVisibleSeats(emptyArea)]
while countDifferences(states[-1], states[-2]) > 0:
     states.append(nextStateUsingVisibleSeats(states[-1]))
printArea(states[-1])
print(f"number of states: {len(states)}")
print(f"seats occupied: {countOccupiedSeats(states[-1])}")
