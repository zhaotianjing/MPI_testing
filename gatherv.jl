# EXAMPLE: gatherv
# here we have 3 ranks

# Gatherv!(sendbuf, recvbuf, comm::Comm; root::Integer=0)

# Each process sends the contents of the buffer sendbuf to the root process. The root stores elements in rank order in the buffer recvbuf.

# sendbuf should be a Buffer object


using MPI

MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
comm_size = MPI.Comm_size(comm)

root = 0

if rank == root
    output = ones(3,6)*999 #same size, uninitialized
    counts = [3,6,9]       # number of elements in each rank
    output_vbuf = VBuffer(output, counts) # VBuffer for gather
else
    output_vbuf =  VBuffer(nothing)
end

local_matrix = ones(3,rank+1)*(rank+1) # rank0: [1     rank1: [2 2   rank2: [3 3 3
                                       #         1             2 2           3 3 3
                                       #         1]            2 2]          3 3 3]

@show rank,local_matrix

MPI.Gatherv!(local_matrix, output_vbuf, root, comm) #Gatherv!(sendbuf, recvbuf,..), recvbuf on the root process should be a VBuffer

if rank == root
    println()
    println("Final matrix")
    println("================")
    @show output
end



# Module julia/1.8.2 loaded 
# (rank, local_matrix) = (0, [1.0; 1.0; 1.0;;])
# (rank, local_matrix) = (2, [3.0 3.0 3.0; 3.0 3.0 3.0; 3.0 3.0 3.0])
# (rank, local_matrix) = (1, [2.0 2.0; 2.0 2.0; 2.0 2.0])

# Final matrix
# ================
# output = [1.0 2.0 2.0 3.0 3.0 3.0; 
#           1.0 2.0 2.0 3.0 3.0 3.0; 
#           1.0 2.0 2.0 3.0 3.0 3.0]
#

# Note that the tyepe must match.
