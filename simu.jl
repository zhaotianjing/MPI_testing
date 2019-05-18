######## THIS IS WRONG!! CANNOT SCATTER INSIDE LOOP.
# using MPI

# function MPI_mv(A,x)
#     MPI.Init()

#     comm = MPI.COMM_WORLD
#     my_rank = MPI.Comm_rank(comm)
#     p = MPI.Comm_size(comm)

#     nRow,nCol=size(A)
#     b_size = Int(nCol/p)
#     ele_size = Int(b_size * nRow)

#     local_A = MPI.Scatter(A,ele_size,0,comm)
#     local_A2 = reshape(local_A,(nRow,b_size))


#     @time for _ in 1:5  

#         local_x = MPI.Scatter(x,b_size,0,comm)

#         local_sum = local_A2 * local_x

#         all_sum = MPI.Allreduce(local_sum, MPI.SUM, comm)

#         x=x .+ 0.1
#     end

#     MPI.Finalize()
# end

# p=50_000
# A=rand(p,p)  #20GB
# x=rand(p)

# MPI_mv(A,x)



####### CAN ONLY DO LIKE:
using MPI
using LinearAlgebra

function runc()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)

    if my_rank==0
        Z = [1.0 2 3 4 5 6;7 8 9 10 11 12;13 14 15 16 17 18;9 8 7 6 5 4; 7 6 5 4 3 2;5 6 7 8 5 4]
        x = [3.0,2,4,6,1,8]
    else
        Z = Float64[]
        x= Float64[]
    end

    Z = MPI.Scatter(Z,12,0,comm) #12
    Z = reshape(Z,(6,2)) #(6,2)
    x = MPI.Scatter(x,2,0,comm)#2
    res = []

    for i in 1:3
        local_Zx = Z*x
        all_sum = MPI.Allreduce(local_Zx, MPI.SUM, comm)
        append!(res,all_sum)
        x = x .+ 1.0
    end

    println(res)
    MPI.Finalize()
end

runc()
