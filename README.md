# Knapsack and tsp

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
units at a time,and the minimum distance is found between each points to be traveled.  The maximum weight able to be carried
is the same each time.  This is essentially finding the maximum amount of items over then over the minimum distance between
those items.  The functions below are attached in their own file.  This is the working code:
```
while length(weights)>0
    
cap=100
    
incumbents=zeros(length(weights)+3)

x_test=Tuple{Int,Int}[]

d,mark=initial_lp(weights,cap,incumbents)

if d!=0
e,f,incumbents=split_func(d,x_test,mark)

while f!=0
e,f,incumbents=split_func(f,e,incumbents)
end
else
    incumbents=mark
end

w=incumbents[1:length(weights)]
w_push=[]
needed=[]
for i in 1:length(weights)
    if w[i]!=1
        push!(w_push,i)
    else
        push!(needed,i)
    end
end

w=weights[w_push]

p=points_for_distance[needed]

Distances=distance_matrix(p)

solution,z_value=b_and_b_tsp(Distances)

for i in 1:length(solution)
    if solution[i]!=1
      push!(pin,(p[solution[i]-1],c[solution[i]-1],i))
    else
        push!(pin,(0,0))
end
end

weights=weights[w_push]
end
```
This is done each time a new grouping 
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
 amount of values.  One purpose for this problem could be for logistics.  A truck could carry a maximum amount of weight.  
 The amount of goods are chosen based on their cost criteria.  Then to minimize the amount of gas consumed the minimum
 amount of distance is traveled in between deliveries of those goods.  
