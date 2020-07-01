# Internship logbook

## Table of Contents
* [2020-07-01](#2020-07-01)
	* [Modification of wdir/datadir](#modify-wdirdatadir-)
	* [Copy results on local directory](#copy-results-on-local-directory-)
	* [Create conda env to HiCExplorer](#create-conda-env-to-hicexplorer-)
	* [Convert HiCPro to h5 format](#convert-hicpro-to-h5-matrix-)
	* [Construction of contact maps](#construction-of-contact-maps-)


# 2020-07-01

## Modify wdir/datadir :

`wdir=/home/jmartin/work/polledHiC/work/test`

`datadir=/home/jmartin/work/polledHiC/data`

Then run README.sh

## Copy results on local directory :
pref=/home/jmartin/work/polledHiC/work/test/nfcorehic
cpdir="hic_results mapping MultiQC pipeline_info"
for dir in $cpdir
do
	scp -r jmartin@genologin.toulouse.inra.fr:$pref/$dir .
done

## Create conda env to HiCExplorer :

```bash
# Load module
module load system/Miniconda3-4.7.10

# Create conda env
conda create --name hicexplorer python=3.6

# Set channels
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# Install hicexplorer
conda install hicexplorer=3.4.3

# Install other dependencies
conda install hic2cool=0.7 cooler=0.8.5 eigen openmp krbalancing=0.0.5 fit_nbinom=1.1 pybedtools=0.8

# Then activate env 
conda activate hicexplorer
```

!! **Not able to create conda env :** *Errno 28 NoSpaceLeftError: No space left on devices* !!

**EDIT :** *After several try, it finished to create it correctly.*

## Convert HiCPro to h5 matrix :

Copy to convertHiC.sh :
```bash
#!/bin/bash

# Set environment variable
wdir=/home/jmartin/work/polledHiC/work/test
rawdir=/home/jmartin/work/polledHiC/work/test/nfcorehic/hic_results/matrix/raw
h5dir=/home/jmartin/work/polledHiC/work/test/nfcorehic/hic_results/matrix/h5_matrix
runid=convertHicpro2h5

# Create outdir
mkdir -p $h5dir

# Convertion
for mat in $rawdir/*.matrix
do
	outname=${mat#*CDFVM_}
	hicConvertFormat --matrices $mat --outFileName $h5dir/$outname --bedFileHicpro ${mat%.matrix}_abs.bed --inputFormat hicpro --outputFormat h5
done
```

**!! WARNING : You have to run this script in a dedicated session _(srun -c 8 --pty bash)_ !!**

## Construction of contact maps :

Copy in createMap.sh :

```bash
#!/bin/bash
#SBATCH -J plotmap
#SBATCH -e plotmap.err
#SBATCH -o plotmap.log
#SBATCH -p workq
#SBATCH --mail-type=END,FAIL
#SBATCH --export=ALL
#SBATCH --cpus-per-task=1
#SBATCH --mem=250G

module purge
module load system/Miniconda3-4.7.10
module load bioinfo/HiCExplorer-v3.4.3

matdir=/home/jmartin/work/polledHiC/work/test/nfcorehic/hic_results/matrix/h5_matrix

cd $matdir

for matrix in *.h5
do
	hicPlotMatrix --matrix $matrix --outFileName ${matrix%.matrix.h5}_map --title ${matrix%.matrix*}
	hicPlotMatrix --matrix $matrix --outFileName ${matrix%.matrix.h5}_log1p_map --log1p --title ${matrix%.matrix*}_log1p
	hicPlotMatrix --matrix $matrix --outFileName ${matrix%.matrix.h5}_log_map --log --title ${matrix%.matrix*}_log
done
```

