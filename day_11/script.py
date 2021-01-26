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

waitingArea = loadWaitingArea('input.txt')

def printWaitingArea(area):
    for row in area:
        for seat in row:
            print(seat, end='')
        print('')

#for row in waitingArea:
#    print(f"{row}\n", end='')

def emptySeat():
    return 'L'

def occupiedSeat():
    return '#'

def floor():
    return '.'

def inWaitingArea(row, col):
    width = len(waitingArea[0])
    height = len(waitingArea)
    return (col >= 0 and row >= 0 and row < height and col < width)

def adjacentSeats(row, col, waitingArea):
    diffs = [ (1, 0), (1, 1), (1, -1), (0, 1), (0, -1), (-1, 0), (-1, -1), (-1, 1) ]
    seats = []
    for diff in diffs:
        dY, dX = diff
        x, y = col + dX, row + dY
        if inWaitingArea(y, x):
            seats.append(waitingArea[y][x])
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

def nextWaitingAreaState(waitingArea):
    nextState = []
    for row_num, row in enumerate(waitingArea):
        newRow = []
        for seat_num, seat in enumerate(row):
            adjSeats = adjacentSeats(row_num, seat_num, waitingArea)
            newSeat = newSeatState(seat, adjSeats)
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
states = [waitingArea, nextWaitingAreaState(waitingArea)]
while countDifferences(states[-1], states[-2]) > 0:
    states.append(nextWaitingAreaState(states[-1]))
printWaitingArea(states[-1])
print(f"number of states: {len(states)}")
print(f"seats occupied: {countOccupiedSeats(states[-1])}")