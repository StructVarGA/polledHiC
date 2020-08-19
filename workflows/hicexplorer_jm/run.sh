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
module load system/Python-3.7.4

# conda activate /home/jmartin/.conda/envs/hicexplorer-3.5

# Creation of sampled_protocols.tsv
echo "Creation of sampled protocols table"
sleep 0.4s ; echo -n '-' ; sleep 0.4s ; echo -n '-' ; sleep 0.4s ; echo -n '-' ; sleep 0.4s ; echo '-'

python make_sampled_protocol.py

echo "DONE"
sleep 0.4s
echo "=== sampled_protocols.sv ==="
cat sampled_protocols.tsv
echo ""
sleep 0.4s

echo "Run of Snakemake"
sleep 0.4s ; echo -n '-' ; sleep 0.4s ; echo -n '-' ; sleep 0.4s ; echo -n '-' ; sleep 0.4s ; echo '-'

snakemake --jobs 2 -p \
  --snakefile /work2/genphyse/dynagen/jmartin/polledHiC/workflows/hicexplorer_jm/Snakefile \
  --directory /work2/genphyse/dynagen/jmartin/polledHiC/workflows/hicexplorer_jm/
