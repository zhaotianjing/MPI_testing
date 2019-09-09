# EXAMPLE: gather
# here we have 3 ranks

using MPI


MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)


if rank == 0
    data = [7.0,8.0,9.0,10.0,11.0,12.0]
else
    data = Float64[]
end

data = MPI.Scatter(data, 2, 0, comm) #each rank has 2 elements

data_gather = MPI.Gather(data, 2, 0, comm)


#print output
if rank == 0
    @show data_gather
end



MPI.Finalize()
