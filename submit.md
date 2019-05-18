```
#!/bin/bash -l
#SBATCH --job-name=MPI_ztj
#SBATCH --ntasks=4
#SBATCH --mem=3000
#SBATCH --time=00:10:00
#SBATCH --partition=high
#SBATCH --mail-type=ALL
#SBATCH --mail-user=tjzhao@ucdavis.edu

module load julia
srun julia test.jl
####SBATCH --ntasks-per-node=1
####SBATCH --nodes=1
```

-N 1 -n 4
using 1 Node, 2 task per node. (4 task)

-N 4 -n 4
using 4 Node, 1 task per node.  (4 task)

-n 4 -c 1
each task allocated 1 CPU (4 CPU)

-n 4 -c 4
each task allocated 4 CPU (16 CPU)

```
-c, --cpus-per-task=
```
