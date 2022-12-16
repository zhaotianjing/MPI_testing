# EXAMPLE: test send and receive

using MPI
MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
@show rank

if rank==0
    data=[7.0,8.0,9.0,10.0]
    MPI.Send(data,1,99,comm) #99 is an unique tag for this message
elseif rank==1
    data=Array{Float64}(undef, 4)
    MPI.Recv!(data,0,99,comm)

    println(data)
end


MPI.Finalize()


# Module julia/1.8.2 loaded 
# rank = 1
# rank = 0
# [7.0, 8.0, 9.0, 10.0]