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

##The first column is the weights sorted in descending value.  The next two together are the points where the 
##items need to go.  These will be saved in a different 
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

weights=collect(x[1] for x in v)
A=collect(x[2] for x in v)
B=collect(x[3] for x in v)
points_for_distance=Tuple{Int,Int}[]

for i in 1:length(A)
    push!(points_for_distance,(A[i],B[i]))
end


cap=100
pin=[]


##A loop is put into place to run until all of the weights are chosen and each resulting distance matrix is solved
##to find the shortest path.  
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

##The resulting "trips" chosen to best optimize the amount carried and also the minimum distance traveled.
##each index of (0,0) is the starting point and end point of coming back to the original starting point 
##which is always the same.  
pin

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
