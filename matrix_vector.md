# Ax=y
```
using MPI

function MPI_mv()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)      
    p = MPI.Comm_size(comm)            

    
    A=[1 2 3 4;
       5 6 7 8]
    x=[9,
      10,
      11,
      12]

    local_A = MPI.Scatter(A,4,0,comm)  #[1,5,2,6]  [3,7,4,8]
    local_A2 = reshape(local_A,(2,2))  #[1 2;      [3 7;
                                       # 5 6]       4 8]

    local_x = MPI.Scatter(x,2,0,comm)  # [9,10] [11,12]

    local_sum = local_A2 * local_x

    all_sum = MPI.Allreduce(local_sum,MPI.SUM, comm)  #sum the partial result
    println(all_sum)

    MPI.Finalize()
end
MPI_mv()
```
