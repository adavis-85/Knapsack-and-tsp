# Knapsack and tsp for logistics

The Knapsack problem is a classic and important part of learning optimization. It is simply a maximization problem.
The maximum amount of items are chosen as to take the most expensive in accordance with the weight. For the purpose of this project the variables are chosen in terms of their weight.
 ```
 (45, 16, 37)
 (42, 1, 40) 
 (36, 20, 21)
 (35, 18, 22)
 (31, 6, 38) 
 (24, 19, 28)
 (19, 11, 23)
 (19, 16, 29)
 (19, 15, 34)
 (7, 15, 38)
```
The first column in the above grouping is the weights arranged in descending order to be more efficient in choosing. The following two columns are the points where each item or variable is to be taken. The second part of this project uses a Traveling Salesman Problem algorithm to find the minimum total distance between each item that needs to be transported.
The data is iterated over and the maximum amount of items chosen based on the weight that can be carried, in this case 100 units at a time,and the minimum distance is found between each points to be traveled. The maximum weight able to be carried is the same each time. This is essentially finding the maximum amount of items over then over the minimum distance between those items. The functions below are attached in their own file. This is the working code:
```
while length(weights)>0
                
cap=100
    
incumbents=zeros(length(weights)+3)

x_test=Tuple{Int,Int}[]

d,mark=initial_lp(weights,cap,incumbents)

if d!=0
e,f,incumbents=split_func(d,x_test,mark)

while  f!=0
e,f,incumbents=split_func(f,e,incumbents)
end
else
    incumbents=mark
end

##here is where its not working.
            
test_var=[]
need=[]               
for i::Int in 1:length(weights)
  if incumbents[i]==1
     push!(test_var,i)
  else
     push!(need,i)
  end
end       
         
d=weights[test_var]
                
p=points_for_distance[test_var]

points_for_distance=points_for_distance[need]
                
Distances=distance_matrix(p)

solution,z_value=b_and_b_tsp(Distances)
            
for i in 1:length(solution)
    if solution[i]!=1
      push!(pin,((p[solution[i]-1],d[solution[i]-1]),i-1))
    else
      push!(pin,(0,0))
    end
end

weights=weights[need]
                
end
```
This is done each time a new grouping of items is chosen. The end trips were then arranged to show travel to and from each grouping , the weight and the order traveled :
```
 (0, 0)             
 (((11, 23), 19), 1)
 (((18, 22), 35), 2)
 (((20, 21), 36), 3)
 (((15, 38), 7), 4) 
 (0, 0)             
 (0, 0)             
 (((6, 38), 31), 1) 
 (((16, 37), 45), 2)
 (((19, 28), 24), 3)
 (0, 0)             
 (0, 0)             
 (((1, 40), 42), 1) 
 (((15, 34), 19), 2)
 (((16, 29), 19), 3)
 (0, 0)    
```
The knapsack problem was solved using the branch and bound method.
https://en.wikipedia.org/wiki/Branch_and_bound Branch and bound is similar to an enumeration tree based search where instead of enumerating over the whole tree, at each node the maximum is chosen. If the node maximum is optimal then that takes the place of the incumbent value if constraints are met. If not an optimal value then the node is split again and the maximum is taken again. This is done until the resulting optimal value is determined infeasible. After this the incumbent value is set and the problem is solved. The maximum or minimum solution is chosen based on the maximum or minimum weights in this problem. Not all weights are tested and this way the branch and bound method is faster than a total tree traversal. For a small amount of points a total enumeration could be performed but not all possibilities could be chosen if there were a much larger value. It could take years to find all possible permutations of a large amount of values. One purpose for this problem could be for logistics. A truck could carry a maximum amount of weight.
The amount of goods are chosen based on their cost criteria. Then to minimize the amount of gas consumed the minimum amount of distance is traveled in between deliveries of those goods.


