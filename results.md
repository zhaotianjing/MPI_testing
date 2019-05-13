# Process 
scatter A before for-loop. Inside each for-loop, scatter x and calculate the matrix-vector multiplication.  


# Code
```
using MPI

function runc()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)
    cluster_size = MPI.Comm_size(comm)

    nRow=50_000
    nCol=50_000

    batch_size = Int(nCol/cluster_size)
    batch_ele = Int(batch_size * nRow)

    if my_rank==0
        ZFull = rand(nRow,nCol)
    else
        ZFull = Float64[]
    end

    local_Z = MPI.Scatter(ZFull,batch_ele,0,comm)
    local_Z = reshape(local_Z,(nRow,batch_size))

    x = rand(nCol)

    println(my_rank)

    @time for i in 1:500
        local_x = MPI.Scatter(x,batch_size,0,comm)
        local_sum = local_Z * local_x
        all_sum = MPI.Allreduce(local_sum, MPI.SUM, comm)
        x = x .+ 0.1
    end

    MPI.Finalize()
end

runc()


# ones(6,6)*ones(6)
# ones(6,6)*(ones(6).+1)
# ones(6,6)*(ones(6).+2)


```


# Time
## big matirx
A: 50_000 by 50_000 matrix  
x: 50_000 length vector
iter: 5  
This is not accurate because the #iter is too small. Thus the time on each task are very different.

| Number of nodes | Number of ntasks-per-node | Time(seconds)| Job ID |
|-----------------|----------------|--------------|--------|
|             1   | 2              |     17     |10632541|
|             1   | 4              | 13        |10632545|
|             1   | 10             | 16        |10632546|
|             1   | 20             | 7         |10632548|
|             2   | 10             | 14        |10632575|
|             2   | 20             | 3         |10632665|
|             2   | 40             | 4.4       |10632666|


iter: 500
This is reliable because the time on each tasks are almost same.

| Number of nodes | Number of ntasks-per-node | Time(seconds)| Job ID |
|-----------------|----------------|--------------|--------|
|              1  |    1 (no MPI)  |     553     |10679486|
|             1   | 2              |     533     |10675501|
|             1   | 4              |   461       |10676580|
|             1   | 10             |   449       |10678461|
|             1   | 20             |    330      |10678701|
|             1   | 50             |     290     |10679265|
|             2   | 2              |     286     |10679100|
|             2   | 4              |    253      |10681163|
|             2   | 10             |   261       |10681263|
|             4   | 1              |    141       |10681632|
|             5   | 1              |     123      |10681695|
|             5   |  2             |    140       |10682209|
|             10   | 1             |    70       |10681800|
|             10   | 2             |    105      |10682034|

No MPI: 
Job ID: 10679486  
Time(seconds): 553

Job ID: 10679974   
Time(seconds): 529

