# Knapsack-and-tsp

The Knapsack problem is a classic and important part of learning optimization.  It is simply a maximization problem.  
The maximum amount of items are chosen as to take the most exensive in accordance with the weight.  For the purpose
of this project the variables are expensive in terms of their weight.  
```
(50, 9, 33) 
 (48, 20, 22)
 (43, 16, 34)
 (36, 1, 32) 
 (31, 3, 21) 
 (26, 9, 25) 
 (14, 9, 28) 
 (5, 14, 36) 
 (5, 11, 38) 
 (4, 1, 36)
```
The first column in the above grouping is the weights arranged in descending order to be more efficient in choosing.  The 
following two columns are the points where each item or variable is to be taken.  The second part of this project uses a 
Traveling Salesman Problem algorithm to find the minimum total distance between each item that needs to be transported.  
The data is iterated over and the maximum amount of items chosen based on the weight that can be carried, in this case 100
units at a time,and the minimum distance is found between each points to be traveled.  This is done each time a new grouping 
of items is chosen.  The end trips were then arranged to show travel to and from each grouping:
```
(0, 0)           
 ((9, 33), 36, 2) 
 ((20, 22), 48, 3)
 (0, 0)           
 (0, 0)           
 ((3, 21), 4, 2)  
 ((9, 25), 5, 3)  
 ((9, 33), 36, 4) 
 ((20, 22), 48, 5)
 (0, 0)           
 (0, 0)           
 ((20, 22), 48, 2)
 ((16, 34), 4, 3) 
 ((9, 33), 36, 4) 
 ((1, 32), 5, 5)  
 (0, 0)
 ```
 The knapsack problem was solved using the branch and bound method.  
 https://en.wikipedia.org/wiki/Branch_and_bound
 Branch and bound is similar to an enumeration tree based search where instead of enumerating over the whole tree, at each node the maximum is chosen.  If the node maximum 
 is optimal then that takes the place of the incumbent value if constraints are met.  If not an optimal value then the node 
 is split again and the maximum is taken again.  This is done until the resulting optimal value is determined infeasible. 
 After this the incumbent value is set and the problem is solved.  The maximum or minimum solution is chosen based on the 
 maximum or minimum weights in this problem.  Not all weights are tested and this way the branch and bound method is faster
 than a total tree traversal.  For a small amount of points a total enumeration could be performed but not all possibilities
 could be chosen if there were a much larger value.  It could take years to find all possible permutations of a large 
 amount of values.  
