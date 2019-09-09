#!/bin/bash -l
#SBATCH --job-name=MPI
#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=100
#SBATCH --time=00:10:00
#SBATCH --partition=high


module load julia/1.1.0

srun julia reduction.jl
