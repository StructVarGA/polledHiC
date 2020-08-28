#!/bin/bash
#SBATCH -J snakemake_hicexplorer
#SBATCH -e snakemake_hicexplorer.err
#SBATCH -o snakemake_hicexplorer.log
#SBATCH -p workq
#SBATCH --mail-type=END,FAIL
#SBATCH --export=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G

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

snakemake --jobs 1 -p -n\
  --snakefile /work2/genphyse/dynagen/jmartin/polledHiC/workflows/hicexplorer_jm/Snakefile \
  --directory /work2/genphyse/dynagen/jmartin/polledHiC/workflows/hicexplorer_jm/

echo "DONE"
echo ""

# # to sum all indivs to get consensus matrices, please uncomment following lines :
# 
# echo "Sum of all indivs. to get 'Consensus matrices'"
# sleep 0.4s ; echo -n '-' ; sleep 0.4s ; echo -n '-' ; sleep 0.4s ; echo -n '-' ; sleep 0.4s ; echo '-'
# 
# mkdir -p hdf5/consensus
# 
# getRes=$(ls -d hdf5/*/merged/* | cut -f 4 -d / | sort | uniq)
# 
# for res in $getRes
# do
#   echo "Matrices to sum :"
#   matrices=$(ls hdf5/*/merged/$res/corrected.h5)
#   echo $matrices
#   echo ""
#   
#   hicSumMatrices -m $matrices -o hdf5/consensus/$res.h5
#   
#   echo "Consensus $res DONE !"
#   echo ""
# done

# # to plot maps from consensus matrices, please fill {} and uncomment following lines :
# 
# mkdir -p plots/consensus
# 
# for mat in hdf5/consensus/*.h5
# do
#   out=${mat##*/}
#   hicPlotMatrix -m $mat -o plots/consensus/${out%.h5}.png --region {chromosome}:{start}-{end} --log
# done
