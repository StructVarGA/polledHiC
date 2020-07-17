#!/bin/sh

wdir= # Set here your working directory 
pathscript=$wdir/HiCExplorer_paths.txt

cd $wdir

echo '' > $pathscript

for trio in $(ls -d */ | sed 's/\///g')
do
  # Set Parametres
  runid=hicexplorer-$trio
  outdir=$wdir/$trio
  script=$outdir/Hic-Explorer_pipeline.sh
  log=$outdir/Hic-Explorer_pipeline.log
  err=$outdir/Hic-Explorer_pipeline.err
  raw_mat=$outdir/hic_results/matrix/raw
  h5_mat=$outdir/hic_results/matrix/h5df
  
  echo '#!/bin/bash
#SBATCH -J '$runid'
#SBATCH -e '$err'
#SBATCH -o '$log'
#SBATCH -p workq
#SBATCH --mail-type=END,FAIL
#SBATCH --export=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

module purge
module load system/Miniconda3-4.7.10
module load bioinfo/HiCExplorer-v2.2.1.1

# Create h5 directory
mkdir -p '$h5_mat'

# Convesrion matrix -> h5df
for mat in '$raw_mat'/*.matrix
do
  bedfile=${mat%.matrix}_abs.bed
  outname=${mat##*trio1.offspring.}
  hicConvertFormat --matrices $mat --outFileName '$h5_mat'/$outname --bedFileHicpro $bedfile --inputFormat hicpro --outputFormat h5
done

# Un-comment these line to create Map.png but it need lot of memory (more than 258G)

# # Create maps
# cd '$h5_mat'

# for mat in *.h5
# do
  # hicPlotMatrix --matrix $matrix --outFileName ${matrix%.matrix.h5}_map --title ${matrix%.matrix*}
  # hicPlotMatrix --matrix $matrix --outFileName ${matrix%.matrix.h5}_log1p_map --log1p --title ${matrix%.matrix*}_log1p
  # hicPlotMatrix --matrix $matrix --outFileName ${matrix%.matrix.h5}_log_map --log --title ${matrix%.matrix*}_log
# done' > $script
  # and finally
  echo $script >> $pathscript
done
