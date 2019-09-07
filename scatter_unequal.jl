using MPI
using LinearAlgebra

function runc()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)
    cluster_size = MPI.Comm_size(comm)
    cluster_size = 2
    nRow = 1
    nCol = 5
    # size1 = nCol÷cluster_size
    # size2 = nCol÷cluster_size+nCol%cluster_size
    # batch_col = [fill(size1,cluster_size-1);size2]
    # batch_ele = Int32.(batch_col * nRow)
    # iCol = batch_col[my_rank+1]
    batch_ele=Int32[2,3]


    if my_rank==0
        Z = [1 2 3 4 5]
    else
        Z = Int64[]
    end


    Z = MPI.Scatterv(Z,batch_ele,0,comm) #12 345
    #Z = reshape(Z,(nRow,iCol))

    @show my_rank,Z

    #if my_rank==0 !WRONG!Gather should run in every rank
        myall = MPI.Gatherv(Z,batch_ele,0,comm)
        @show my_rank,myall
    #end

    MPI.Finalize()
end

runc()
