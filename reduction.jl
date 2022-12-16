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
@show rank,data

#partial dot
small_dot = dot(data,data)
@show rank,small_dot

#all dot
all_dot = MPI.Reduce(small_dot, +, 0, comm)

if rank==0
    @show all_dot
end

MPI.Finalize()


# Module julia/1.8.2 loaded 
# (rank, data) = (0, [7.0, 8.0])
# (rank, small_dot) = (0, 113.0)
# (rank, data) = (1, [9.0, 10.0])
# (rank, data) = (2, [11.0, 12.0])
# (rank, small_dot) = (2, 265.0)
# (rank, small_dot) = (1, 181.0)
# all_dot = 559.0

