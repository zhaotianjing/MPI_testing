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


# In uneven  randn(),1.why rank0 different: because alpha=randn() already use seed. 
# 2.why rank_last is different: because rand(my_rank_size) use more seed than others
