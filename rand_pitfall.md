If we don't add `Random.seed!(1234)`, then each task will generate different random number.

```
using MPI
using Random
using Distributions

function runc()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)
    Random.seed!(1234)

    s = randn(10)
    @show s[1:10]
    MPI.Barrier(comm)

    y = rand(10)
    @show y
    MPI.Barrier(comm)

    z = rand(Chisq(1000))
    @show z
    MPI.Barrier(comm)

    MPI.Finalize()
end

runc()

```
