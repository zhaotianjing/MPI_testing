# EXAMPLE: gatherv
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
data = MPI.Scatterv(data, counts, 0, comm) 

data_gather=MPI.Gatherv(data, counts, 0, comm)


if rank ==0
    @show data_gather
end

MPI.Finalize()


## output:
# data_gather = [7.0, 8.0, 9.0, 10.0, 11.0]

