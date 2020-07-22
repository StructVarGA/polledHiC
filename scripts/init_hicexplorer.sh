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
  
  sp=${trio%.*}
  sp=${sp#*.}
  
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

# Sum of each resolution for species
mkdir -p '$hic_studies/$sp'

cd '$h5_mat'

for mat1 in *.h5
do
  echo mat1 = $mat1
  for mat2 in *.h5
  do
    echo mat2 = $mat2
    if [[ "$mat1" != "$mat2" ]]; then
      echo "IF 1 OKAY"
      if [[ "${mat1#*_*_*_}" == "${mat2#*_*_*_}" ]] ; then
        echo "IF 2 OKAY"
        hicSumMatrices --matrices $mat1 $mat2 --outFileName SUM_'$sp'_${mat1#*_*_*_}
      fi
    fi
  done
done' > $script
  # and finally
  echo $script >> $pathscript
done
