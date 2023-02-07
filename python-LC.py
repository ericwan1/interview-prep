# https://leetcode.com/problems/insert-interval/
n = len(intervals)
i, output = 0,[]

while (i<n) and intervals[i][1] < newInterval[0]:
    output.append(intervals[i])
    i+=1
    
while (i<n) and intervals[i][0] <= newInterval[1]:
    newInterval[0] = min(intervals[i][0], newInterval[0])
    newInterval[1] = max(intervals[i][1], newInterval[1])
    i+=1
    
output.append(newInterval)

while i<n:
    output.append(intervals[i])
    i+=1
    
return output