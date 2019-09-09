# EXAMPLE: scatterv
# here we have 3 ranks

using MPI


MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)


if rank == 0
    data = [7.0,8.0,9.0,10.0,11.0]
else
    data = Float64[]
end

counts=Int32[2,2,1]
data = MPI.Scatterv(data, counts, 0, comm) #each rank has 2 elements

@show rank, data


MPI.Finalize()


## output:
# (rank, data) = (2, [11.0])
# (rank, data) = (0, [7.0, 8.0])
# (rank, data) = (1, [9.0, 10.0])

