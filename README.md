# Instruction

How to @time a Julia MPI code? [timing.md](https://github.com/zhaotianjing/MPI_testing/blob/master/timing.md)

How to run Julia MPI code on campus server? [running.md](https://github.com/zhaotianjing/MPI_testing/blob/master/running.md)

How to use MPI reduce? [dot.md](https://github.com/zhaotianjing/MPI_testing/blob/master/dot.md)

How to use MPI scatter/gather? [scatter_gather_example.jl](https://github.com/zhaotianjing/MPI_testing/blob/master/scatter_gather_example.jl)  
* Note, Julia is a column-major language, so matrix can only be scattered by column, not by row. And the parallel matrix\*vector can be achieved only by columnwise block-striped decompusition.
