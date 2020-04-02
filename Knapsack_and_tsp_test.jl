##Random points are chosen to make the data unbiased.
a=rand(1:20,10)
b=rand(21:40,10)
c=rand(1:50,10)
v=Tuple{Int,Int,Int}[]

for i in 1:length(c)
    push!(v,(c[i],a[i],b[i]))
end

v=sort(collect(v),by=x->x[1],rev=true)

v

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


##A loop is put into place to run until all of the weights are chosen and each resulting distance matrix is solved
##to find the shortest path.  
while length(weights)>0
                
            
    
cap=100

##Sets the incumbent for each following function.  
incumbents=zeros(length(weights)+3)

x_test=Tuple{Int,Int}[]

##Solving the first LP relaxation i.e. branch and bound.
d,mark=initial_lp(weights,cap,incumbents)

if d!=0
##The greater of the two paths from the selected node.  Each smaller is ignored (pruned) and the greater is then split
##again.
e,f,incumbents=split_func(d,x_test,mark)

while  f!=0
##Splits again on a loop until found infeasible.
e,f,incumbents=split_func(f,e,incumbents)
end
else
    incumbents=mark
end
     
##The array for the items picked from the branch and bound.
test_var=[]
##The array for the items not picked to be able to iterate over the next time through the loop.
need=[]        
    
for i::Int in 1:length(weights)
    if incumbents[i]==1
        push!(test_var,i)
    else
        push!(need,i)
    end
end       
     
##Variable to iterate over to show the trip after the traveling salesman is solved.
d=weights[test_var]

##Points selected from the optimized knapsack problem.
p=points_for_distance[test_var]

##Setting the points for the next time through the loop.  Selected points will not be selected again.
points_for_distance=points_for_distance[need]

##Function to construct the distance matrix.
Distances=distance_matrix(p)

##Function to solve the distance matrix for the minimum path.
solution,z_value=b_and_b_tsp(Distances)
 
##The trips selected from the maximum carried and the minimum distance.
for i in 1:length(solution)
    if solution[i]!=1
    push!(pin,((p[solution[i]-1],d[solution[i]-1]),i-1))
    else
    push!(pin,(0,0))
end
end

##Weights selected will not be selected again.
    weights=weights[need]
                
end
##The resulting "trips" chosen to best optimize the amount carried and also the minimum distance traveled.
##each index of (0,0) is the starting point and end point of coming back to the original starting point 
##which is always the same.  

pin

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
