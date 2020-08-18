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
sleep 0.8s ; echo -n '-' ; sleep 0.8s ; echo -n '-' ; sleep 0.8s ; echo -n '-' ; sleep 0.8s ; echo '-'

python - << 'EOS'
import os
import glob

nfcore_dir = glob.glob('/work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm/*/')

tsv = []
for prot in nfcore_dir:
   path = prot + 'hic_results/matrix/raw/*'
   for mat in glob.glob(path):
     sample = '.'.join(mat.split('/')[-1].split('.')[:2])
     protocol = mat.split('/')[-1].split('.')[-2].split('_')[0]
     matrixprefix = '/'.join(mat.split('/')[:-1]) + '/' + sample
     line = sample + "\t" + protocol + "\t" + matrixprefix
     if line not in tsv:
        tsv.append(line)

tsv.sort()
with open('sampled_protocols.tsv', 'w') as fh:
   print('sample', 'protocol', 'matrixprefix', sep="\t", file = fh)
   for l in tsv:
      print(l, file = fh)
EOS

echo "DONE"
sleep 0.8s
echo "=== sampled_protocols.sv ==="
cat sampled_protocols.tsv
echo ""
sleep 0.8s

echo "Run of Snakemake"
sleep 0.8s ; echo -n '-' ; sleep 0.8s ; echo -n '-' ; sleep 0.8s ; echo -n '-' ; sleep 0.8s ; echo '-'

snakemake --jobs 2 -p -n \
  --snakefile /work2/genphyse/dynagen/jmartin/polledHiC/workflows/hicexplorer_jm/Snakefile \
  --directory /work2/genphyse/dynagen/jmartin/polledHiC/workflows/hicexplorer_jm/
