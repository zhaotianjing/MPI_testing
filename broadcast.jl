#EXAMPLE: broadcasting

using MPI


MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)


if rank == 0
    data = [7.0,8.0,9.0,10.0]
else
    data = Float64[]
end

data = MPI.bcast(data, 0, comm)
@show rank, data


MPI.Finalize()

# Module julia/1.8.2 loaded 
# (rank, data) = (2, [7.0, 8.0, 9.0, 10.0])
# (rank, data) = (0, [7.0, 8.0, 9.0, 10.0])
# (rank, data) = (1, [7.0, 8.0, 9.0, 10.0])