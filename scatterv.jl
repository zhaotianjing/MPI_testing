# EXAMPLE: scatterv
# here we have 3 ranks

using MPI

MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
comm_size = MPI.Comm_size(comm)

root = 0

# Scatterv!(sendbuf, recvbuf, comm::Comm; root::Integer=0)
#   Splits the buffer sendbuf in the root process into Comm_size(comm) chunks 
#   and sends the jth chunk to the process of rank j-1 into the recvbuf buffer.
#   sendbuf on the root process should be a VBuffer. 

if rank == root
    test = [1.0,2, 3,4, 5,6]        # Vector & FLOAT64 !!!!!!!
    test_vbuf = VBuffer(test, [2,2,2])
else
    test_vbuf = VBuffer(nothing)
end

local_test = MPI.Scatterv!(test_vbuf, zeros(2), root, comm) # Vector & FLOAT64 !!!!!!!

@show rank,local_test

MPI.Finalize()


# Module julia/1.8.2 loaded 
# (rank, local_test) = (2, [5.0, 6.0])
# (rank, local_test) = (1, [3.0, 4.0])
# (rank, local_test) = (0, [1.0, 2.0])

