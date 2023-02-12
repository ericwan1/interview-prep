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

# https://leetcode.com/problems/k-closest-points-to-origin/
import heapq
import math

heap = []

for (x, y) in points:
    # this is negative, because when we pop from our heap, the minimum element is returned.
    # if we set the distance to be negative, then the calculated smallest distances become 
    # larger in value than the original largest distances, which are then popped. 
    distance = -(math.sqrt(x*x + y*y))
    if len(heap) == k:
        heapq.heappushpop(heap, (distance, x, y))
    else:
        heapq.heappush(heap, (distance, x, y))

return [(x,y) for (distance, x, y) in heap]

# https://leetcode.com/problems/longest-substring-without-repeating-characters/
seen = set()
left = 0
longest_seen_len = 0
curr_seen_len = 0

for right in range(len(s)):
    while s[right] in seen:
        seen.remove(s[left])
        curr_seen_len -= 1
        left += 1

    seen.add(s[right])
    curr_seen_len += 1
    longest_seen_len = max(longest_seen_len, curr_seen_len)

return longest_seen_len

# https://leetcode.com/problems/3sum/
res = []
nums.sort()
for i in range(len(nums)-2):
    if i > 0 and nums[i] == nums[i-1]:
        continue
    l, r = i+1, len(nums)-1
    while l < r:
        s = nums[i] + nums[l] + nums[r]
        if s < 0:
            l +=1 
        elif s > 0:
            r -= 1
        else:
            res.append((nums[i], nums[l], nums[r]))
            while l < r and nums[l] == nums[l+1]:
                l += 1
            while l < r and nums[r] == nums[r-1]:
                r -= 1
            l += 1 
            r -= 1
return res