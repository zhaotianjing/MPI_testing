# EXAMPLE: reduction
# here we have 3 ranks

using MPI, LinearAlgebra


MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)


if rank == 0
    data = [7.0,8.0,9.0,10.0,11.0,12.0]
else
    data = Float64[]
end

# partial data
data = MPI.Scatter(data, 2, 0, comm) #each rank has 2 elements
#partial dot
small_dot = dot(data,data)

#all dot
all_dot = MPI.Reduce(small_dot, +, 0, comm)

if rank==0
    @show all_dot
end

MPI.Finalize()


## output:
# all_dot = 559.0

