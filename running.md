# How to run MPI in Julia

run julia MPI code on server:
```
srun -N 1 -n 3 -t 1 julia ./hello_mpi.jl
```
N: number of nodes  
n: number of jobs  
t: time limite for one job. -t -1 is one minute  

For large jobs, putting the above srun command inside a sbatch script.
```
#!/bin/bash -l
#SBATCH --job-name=parallelJulia
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30000

module load julia
srun julia hello_mpi.jl
```
