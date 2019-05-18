# if no seed, each task will have different result

using MPI
using Random

function runc()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)
    Random.seed!(1234)

    s = randn(10_000)
    @show s[1:10]

    MPI.Finalize()
end

runc()
