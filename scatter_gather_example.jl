# run by srun -N 2 -n 2 -t 1 julia ./scatter_gather_example.jl
# output: [2, 4, 6, 8, 10, 12, 14, 16]


using MPI
function t()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)

    if my_rank==0
        v = [1,2,3,4,5,6]
    else
        v=Int64[]
    end
    v=MPI.Scatter(v,3,0,comm)

    v_all=MPI.Gather(v,0,comm) #Each process sends sendbuf to the root process.(so each process should run MPI.Gather)
    if my_rank==0
        @show v_all
    end


    MPI.Finalize()
end

t()







###################################################### Note: Julia is column-major language
# srun -N 2 -n 2 -t 1 julia ./xx.jl
# A:[1,2,3,4
#    5,6,7,8]
# output:[1,5,2,6]  [3,4,7,8]

using MPI
using LinearAlgebra


function example1()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)      #0,1
    p = MPI.Comm_size(comm)            #2
    n_element = 4

    A=[1 2 3 4;5 6 7 8]
    local_A = MPI.Scatter(A,n_element,0,comm)
    println(local_A)

    MPI.Finalize()
end


example1()
