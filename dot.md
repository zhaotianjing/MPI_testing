
```
using MPI

function msplit(N, P, i)
    base, rem = divrem(N, P)
    from = (i - 1) * base + min(rem, i - 1) + 1
    to = from + base - 1 + (i ≤ rem ? 1 : 0)
    from : to
end

function mydot(x,y)
    n=length(x)
    s = 0.0
    for i=1:n
        s += x[i]*y[i]
    end
    return s
end

function mpi_dot(a,b,n)
    comm = MPI.COMM_WORLD
    MPI.Barrier(comm)

    myid = MPI.Comm_rank(comm)      #0,1,2,3...n-1
    numprocs = MPI.Comm_size(comm)  #n

    local_x = a[msplit(n,numprocs,myid+1)]
    local_y = b[msplit(n,numprocs,myid+1)]
    local_sum = mydot(local_x,local_y)

    allsum = MPI.Reduce(local_sum,MPI.SUM, 0, comm)
end

function run_mpi_dot(x,y,n)
    MPI.Init()
    [mpi_dot(x*i,y,n) for i in 1:1000]
    MPI.Finalize()
end

n=10_000
x=randn(n)
y=randn(n)


@time run_mpi_dot(x,y,n)

```

## Allreduce
```
function mpi_dot(a,b,n)
    comm = MPI.COMM_WORLD

    myid = MPI.Comm_rank(comm)      #0,1,2,3
    numprocs = MPI.Comm_size(comm)  #4

    local_x = a[msplit(n,numprocs,myid+1)]
    local_y = b[msplit(n,numprocs,myid+1)]
    local_sum = mydot(local_x,local_y)

    allsum = MPI.Allreduce(local_sum,MPI.SUM, comm)

    if myid==0
        println(allsum)
    end
    
end
```
