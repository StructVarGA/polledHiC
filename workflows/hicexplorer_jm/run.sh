#!/bin/bash
#SBATCH -J snakemake_hicexplorer
#SBATCH -e snakemake_hicexplorer.err
#SBATCH -o snakemake_hicexplorer.log
#SBATCH -p workq
#SBATCH --mail-type=END,FAIL
#SBATCH --export=ALL
#SBATCH --cpus-per-task=2
#SBATCH --mem=32G

module purge
module load system/Miniconda3-4.7.10

conda activate /home/jmartin/.conda/envs/hicexplorer-3.5

snakemake --jobs 2 -p -n \
  --snakefile /work2/genphyse/dynagen/jmartin/polledHiC/workflows/hicexplorer_jm/Snakefile \
  --directory /work2/genphyse/dynagen/jmartin/polledHiC/workflows/hicexplorer_jm/

