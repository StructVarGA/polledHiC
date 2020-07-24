#!/bin/bash
#SBATCH -J hicexplorer-polledHiC
#SBATCH -e hicexplorer-polledHiC.err
#SBATCH -o hicexplorer-polledHiC.log
#SBATCH -p workq
#SBATCH --mail-type=END,FAIL
#SBATCH --export=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

module purge
module load system/Miniconda3-4.7.10
module load bioinfo/HiCExplorer-v2.2.1.1
module load system/Python-3.7.4

# Set working environment
wdir=/work2/genphyse/dynagen/jmartin/polledHiC/work
hic_studies=$wdir/hic_studies
sum_path=/work2/genphyse/dynagen/jmartin/polledHiC/scripts/sum_matrices.py

cd $wdir

for trio in $(ls -d */ | sed 's/\///g')
do
  # Set Parametres
  outdir=$wdir/$trio
  raw_mat=$outdir/hic_results/matrix/raw
  h5_mat=$outdir/hic_results/matrix/h5df

  # h5df matrix's directory
  mkdir -p $h5_mat

  # Conversion raw matrix -> h5df
  if [ -d $raw_mat ] ; then
    for mat in $raw_mat/*.matrix
    do
      bedfile=${mat%.matrix}_abs.bed
      outname=${mat##*trio1.offspring.}
      hicConvertFormat --matrices $mat --outFileName $h5_mat/$outname --bedFileHicpro $bedfile --inputFormat hicpro --outputFormat h5
    done
  fi
done

# Sum matrices 
python3 $sum_path

