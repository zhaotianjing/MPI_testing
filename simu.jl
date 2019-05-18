######## THIS IS WRONG!! CANNOT SCATTER INSIDE LOOP.
using MPI

function MPI_mv(A,x)
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)
    p = MPI.Comm_size(comm)

    nRow,nCol=size(A)
    b_size = Int(nCol/p)
    ele_size = Int(b_size * nRow)

    local_A = MPI.Scatter(A,ele_size,0,comm)
    local_A2 = reshape(local_A,(nRow,b_size))


    @time for _ in 1:5  

        local_x = MPI.Scatter(x,b_size,0,comm)

        local_sum = local_A2 * local_x

        all_sum = MPI.Allreduce(local_sum, MPI.SUM, comm)

        x=x .+ 0.1
    end

    MPI.Finalize()
end

p=50_000
A=rand(p,p)  #20GB
x=rand(p)

MPI_mv(A,x)
