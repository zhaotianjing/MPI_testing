# this can avoid that the random number generated by each task is different.

using MPI
using Random

function runc()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)
    if my_rank ==0
        x=randn(4)
    else
        x=Float64[]
    end
    x=MPI.bcast(x,0,comm)
    @show x

    MPI.Finalize()
end

runc()