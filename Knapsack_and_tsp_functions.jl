##Using branch and bound the original LP relaxation is solved in the following function.  The first spot
##to branch on is returned as spot and an opening incumbent value is chosen as a lower bound.
function initial_lp(w,b,inc)   
    
    spot=0
x_initial=zeros(length(w))
c=b
  
for i in 1:length(w)
            if w[i]<=c
        x_initial[i]=1
        c-=w[i]
            inc[i]=1
        else
        x_initial[i]=c/w[i]
        spot=i
            
        break
    end
end
    
    inc[length(x_initial)+3]=inc[1:(length(x_initial))]'*w
    
    return spot,inc
end

##After the original LP relaxation the resulting index will tell the following function where to split and to
##see if either 0 or 1 will be either an incumbent or split yet again.  The tests for each 0 or 1 are entered
##into a matrix and then the maximum value is taken if none are chosen as an incumbent.  Incumbents are only chosen
##if greater than a previous incumbent and also has a feasible basis.
function split_func(d,x,incumbents)

    top::Int64=length(weights)
    split_matrix=zeros(2,top+3)
    spot=0
    to_insert=0
    obj_value_for_split=0
    
    for i::Int in 0:1
        
    c=cap
        
    split_matrix[i+1,d]=i
        
      split_matrix[i+1,collect(x[1] for x in x)]=collect(x[2] for x in x)
        
    c-=split_matrix[i+1,1:top]'*weights
        
    for j::Int in 1:top
        if j !=d&&j ∉ collect(x[1] for x in x)
             
                    if weights[j]<=c
                split_matrix[i+1,j]=1
                c-=weights[j]
            else
                split_matrix[i+1,j]=c/weights[j]
               split_matrix[i+1,top+1]=i
                split_matrix[i+1,top+2]=j
                 split_matrix[i+1,top+3]=sum(split_matrix[i+1,k] for k in 1:top)
                break
            end
        end
    end
                     
        
    if split_matrix[i+1,top+3]>obj_value_for_split&&split_matrix[i+1,top+3]%1!=0
                obj_value_for_split=split_matrix[i+1,top+3]
                    spot=split_matrix[i+1,top+2]
                spot=floor(Int8,spot)
                to_insert=split_matrix[i+1,top+1]
                to_insert=floor(Int8,to_insert)
        elseif sum(split_matrix[i+1,1:top])%1==0
            split_matrix[i+1,top+3]=split_matrix[i+1,1:top]'*weights
            if split_matrix[i+1,top+3]<=cap&&split_matrix[i+1,top+3]>incumbents[top+3]
                incumbents=split_matrix[i+1,:]
            end
        end
        
    end

    push!(x,(d,to_insert))
    
    return x,spot,incumbents
end

##Show the distance between points which are cartesian but could also be 
##latitude and longitude though function would need to be altered.

function hypotenuse(x)
    
       right=(x[1][1]-x[2][1])^2
       left=(x[1][2]-x[2][2])^2
       return(sqrt(right+left))
       end

##Takes in a list of points starting at whichever is desired.  For demonstration purposes
##the beginning point is at the origin (0,0).  Then calculates the distance from each individual
##point to all others 
##for example for three points:
## 0->1
## 0->2
## 0->3
##would be the first row with the row beginning at the distance of the point to itself 
##which would be zero.

function distance_matrix(list)
              new=Tuple{Int,Int}[]
              push!(new,(0,0))
              for i in 1:length(list)
              push!(new,(list[i]))
              end
               list=new
              n=length(list)
              mat=zeros(n,n)
              for i in 1:n
              for j in 1:n
              t=(list[i],list[j])
              mat[i,j]=hypotenuse(t)
              end
              end
              return mat
              end

##This function solves a distance matrix for the traveling salesman problem.  This is useful to find the shortest path
##between a set of points having to travel through all of the points before returning to the original position.

function b_and_b_tsp(matrix)
    matrix=convert(Matrix{Float64},matrix)
    b::Int=sqrt(length(matrix))
    
    ##This is the upper bound for the problem.  This is a minimization problem so the minimum objective value 
    ##needs to be found.  If we were maximizing then we would use a lower bound first=[-Inf,-Inf,-Inf,-Inf].
    first=[Inf;Inf;Inf;Inf]
    ##This is the objective value to be returned after the shortest path is found.
    n_for_return=0  
 
    ##The loop starts at two becaus the first point in the list is the beginning point.  The loop also starts at 2
    ##because in a distance matrix the nodes cannot visit each other.  The diagonal is all zeros.
    for i::Int in 2:b
        
        
nodes=[]
t=[]
a=i
push!(nodes,1)
push!(nodes,i)
push!(t,matrix[1,i])

for j::Int in 2:b
    
    
   ##When all the nodes are visited.
    if length(nodes)==b
        break
    end
            
    ##The minimum of each row is found based off of the node visited, finding the shortest path between nodes
    ##that have not yet been visited.  The "need" variable is needed to find the first occurence of the minimum
    ##value from the present node.  This creates an array to choose from as long as the node isn't previously 
    ##visited it will be used.  
    d=minimum(matrix[a,k] for k::Int in 1:b if k ∉ nodes && k!=i)
    need=findall(isequal(d),matrix[a,:])
                push!(t,d)
                        
                for l::Int in 1:length(need)
                    if need[l] ∉ nodes
                push!(nodes,need[l])
                        a=need[l]
                    break
                    end
                end
                
            end
            
                
                    push!(nodes,1)
                    last=nodes[b]
                    nay=matrix[last,1]
                    push!(t,nay)
                
                    if sum(t)<sum(first)
                        first=t
                        n_for_return=nodes
                        end
                end
            z_return=sum(first)
                
                
                return n_for_return,  z_return   
        
            end
