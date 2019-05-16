```
using MPI
using LinearAlgebra

function runc()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)

    if my_rank==0
        Z = [1.0 2 3 4 5 6;7 8 9 10 11 12;13 14 15 16 17 18;9 8 7 6 5 4; 7 6 5 4 3 2;5 6 7 8 5 4]
    else
        Z = Float64[]
    end

    Z = MPI.Scatter(Z,12,0,comm) #12
    Z = reshape(Z,(6,2)) #(6,2) local Z
    x = MPI.Scatter(x,2,0,comm)#2 local x

    for i in 1:3
        local_Zx = Z*x  #local Z*x
        all_sum = MPI.Allreduce(local_Zx, MPI.SUM, comm)  #all Z*x
        println(all_sum)
        x = x .+ 1.0
    end
    MPI.Finalize()
end

runc()
```
