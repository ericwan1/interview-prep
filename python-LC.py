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

# https://leetcode.com/problems/01-matrix/
dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]]
m, n = len(matrix), len(matrix[0])
queue = collections.deque()

res = [[-1 for _ in range(n)] for _ in range(m)]

for i in range(m):
    for j in range(n):
        if matrix[i][j] == 0:
            # The distance to itself is 0 and add all sources here to queue
            res[i][j] = 0
            queue.append((i, j))
            
while queue:
    curI, curJ = queue.popleft()
    for i, j in dirs:
        neighBorI, neighBorJ = curI + i, curJ + j
        # Validate all the neighbors and validate the distance as well
        if 0 <= neighBorI < m and 0 <= neighBorJ < n and res[neighBorI][neighBorJ] == -1:
            res[neighBorI][neighBorJ] = res[curI][curJ] + 1
            queue.append((neighBorI, neighBorJ))

return res