#!/bin/bash
#SBATCH -J snakemake_nfcore-hic
#SBATCH -e snakemake_nfcore-hic.err
#SBATCH -o snakemake_nfcore-hic.log
#SBATCH -p workq
#SBATCH --mail-type=END,FAIL
#SBATCH --export=ALL
#SBATCH --cpus-per-task=2
#SBATCH --mem=24G

module purge
module load system/Miniconda3-4.7.10
module load bioinfo/nfcore-Nextflow-v19.04.0

conda activate /home/jmartin/.conda/envs/hicexplorer-3.5

snakemake --jobs 1 -p \
  --snakefile /work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic/Snakefile \
  --directory /work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic/
