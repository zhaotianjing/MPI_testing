using MPI
using LinearAlgebra

function runc()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)

    if my_rank==0
        Z = [1,2,3,4,5]
    else
        Z = Int64[]
    end


    Z = MPI.Scatterv(Z,Int32[3,2],0,comm) #12

    @show Z

    MPI.Finalize()
end

runc()
