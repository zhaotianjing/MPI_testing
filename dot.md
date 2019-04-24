run julia MPI code on server:
```
srun -N 1 -n 3 -t 1 julia ./01-hello.jl
```
N: number of nodes  
n: number of jobs  
t: time limite for one job. -t -1 is one minute  

For large jobs, putting the above srun command inside a sbatch script.

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
