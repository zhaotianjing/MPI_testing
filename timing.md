# How @time works in Julia MPI

machine: farm server

code:
```
function test_time()
    MPI.Init()
    comm = MPI.COMM_WORLD
    MPI.Barrier(comm)

    myid = MPI.Comm_rank(comm)      # 0, 1, 2
    numprocs = MPI.Comm_size(comm)  # 3

    sleep(10*myid)                  # 0s, 10s, 20s
    local_sum = 2

    allsum = MPI.Reduce(local_sum,MPI.SUM, 0, comm)

    MPI.Finalize()
end

@time test_time()
```

## 1
```
srun -N 1 -n 3 -t 1 julia ./MPI_time_test.jl
```

```
 20.655815 seconds (487.56 k allocations: 24.423 MiB, 0.03% gc time)
 21.225218 seconds (487.56 k allocations: 24.423 MiB, 0.02% gc time)
 20.668072 seconds (487.56 k allocations: 24.423 MiB, 0.03% gc time)
```

## 2
```
srun -N 2 -n 4 -t 1 julia ./MPI_time_test.jl
```


```
 30.834807 seconds (487.56 k allocations: 24.423 MiB, 0.02% gc time)
 31.132843 seconds (487.56 k allocations: 24.423 MiB, 0.02% gc time)
 31.138776 seconds (487.56 k allocations: 24.423 MiB, 0.02% gc time)
 30.843462 seconds (487.56 k allocations: 24.423 MiB, 0.02% gc time)
```

## 3
```
srun -N 4 -n 4 -t 1 julia ./MPI_time_test.jl
```

```
 31.143664 seconds (487.56 k allocations: 24.423 MiB, 0.01% gc time)
 30.880344 seconds (487.56 k allocations: 24.423 MiB, 0.01% gc time)
 30.789627 seconds (487.56 k allocations: 24.423 MiB, 0.01% gc time)
 30.783080 seconds (487.56 k allocations: 24.423 MiB, 0.01% gc time)

```

## Conclusion
Use maximum time recording as its real time.


