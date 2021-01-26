import waiting_area

data = waiting_area.loadAreaDataFromFile('input.txt')
adjacentRuleArea = waiting_area.AdjacentRuleWaitingArea(data)
visibleRuleArea = waiting_area.VisibleRuleWaitingArea(data)

print(adjacentRuleArea.findStableState().countOccupiedSeats())  # =>2270
print(visibleRuleArea.findStableState().countOccupiedSeats())   # => 2042