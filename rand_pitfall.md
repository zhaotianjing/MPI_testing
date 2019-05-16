If we don't add `Random.seed!(1234)`, then each task will generate different random number.

```
using MPI
using Random

function runc()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)
    Random.seed!(1234)

    s = randn(2)
    println(my_rank, s)

    MPI.Finalize()
end

runc()
```
