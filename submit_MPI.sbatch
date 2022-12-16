#!/bin/bash -l
#SBATCH --job-name=MPI
#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=100
#SBATCH --time=00:10:00
#SBATCH --partition=high
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=tjzhao@ucdavis.edu

module load julia

srun julia reduction.jl
# srun julia gatherv.jl
# srun julia gather.jl
# srun julia scatterv.jl
# srun julia scatter.jl
# srun julia broadcast2.jl
# srun julia send_receive.jl
