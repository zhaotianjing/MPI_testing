# run by srun -N 2 -n 2 -t 1 julia ./scatter_gather_example.jl
# output: [2, 4, 6, 8, 10, 12, 14, 16]


using MPI

function example1()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)      #0,1
    p = MPI.Comm_size(comm)            #2

    A=[1,2 ,3 ,4, 5, 6, 7, 8]

    local_A = MPI.Scatter(A,4,0,comm)  #[1234] [5678]


    local_res = local_A*2

    #print final result
    res = MPI.Gather(local_res,0,comm)

    if my_rank==0
        println(res)
    end

    MPI.Finalize()
end

example1()
