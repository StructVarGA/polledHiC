# Internship logbook

## Table of Contents
* [2020-07-01](#2020-07-01)
	* [Modification of wdir/datadir](#modify-wdirdatadir-)
	* [Copy results on local directory](#copy-results-on-local-directory-)
	* [Create conda env to HiCExplorer](#create-conda-env-to-hicexplorer-)
	* [Convert HiCPro to h5 format](#convert-hicpro-to-h5-matrix-)
	* [Construction of contact maps](#construction-of-contact-maps-)
* [2020-07-02](#2020-07-02)
	* [Move Conda Directory](#move-conda-directory-)
	* [Link to the main data](#link-to-the-main-data-)
	* [Meeting at 11:00 AM](#meeting-at-1100-am-)

# 2020-07-01

## Modify wdir/datadir :

`wdir=/home/jmartin/work/polledHiC/work/test`

`datadir=/home/jmartin/work/polledHiC/data`

Then run README.sh

## Copy results on local directory :

```bash
pref=/home/jmartin/work/polledHiC/work/test/nfcorehic
cpdir="hic_results mapping MultiQC pipeline_info"
for dir in $cpdir
do
	scp -r jmartin@genologin.toulouse.inra.fr:$pref/$dir .
done
```

## Create conda env to HiCExplorer :

```bash
# Load module
module load system/Miniconda3-4.7.10

# Create conda env
conda create --name hicexplorer python=3.6

# Activate env 
conda activate hicexplorer

# Set channels
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# Install other dependencies
conda install hic2cool=0.7 cooler=0.8.5 eigen openmp krbalancing=0.0.5 fit_nbinom=1.1 pybedtools=0.8

# Then Install hicexplorer
conda install hicexplorer=3.4.3
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

# 2020-07-02

## Move Conda Directory :

I removed all the content of `~/.conda/` directory and I created a directory in the `save directory`.

When it's done, I created a symoblinc link from `~/save/.conda/` to `~/.conda/`. Normally, this should be prevent the *Errno25 NoSpaceLeftError*.

I put in place a new conda environment doing (this procedure)[#copy-results-on-local-directory-].

As expected, I didn't have the issue *Errno28*.

## Link to the main data :

I had to create a link with the main data, respecting this hierarchy.

```
├── polledHiC
│   ├── data
|   |    ├── reads
|   |    |    ├── trio1.mother.protocolA
|   |    |    ├── trio1.mother.protocolB
|   |    |    ├── trio1.offspring.protocolA
|   |    |    └── ...
|   |    └── genome
```
Each subdir should contains symbolic links to HiC fastq files of the sequoccin hic repository datadir.

First, I extracted a list of all the reads available on that directory :
```bash
ls /work2/project/seqoccin/data/reads/hic/bos_taurus > list_file.txt
```

After that, I extract the name for all needed directory :
```bash
for file in $(cat list_file.txt) ; do echo ${file%%_*} ; done | \
sed 's/.run*.//g' | sort | uniq > directory_to_create.txt
```

At this moment, if I look in this file, I have one line for each datadir I want to create :
```
trio1.father.Arima
trio1.father.Dovetail
trio1.father.Maison
trio1.father.PhaseG
trio1.mother.Arima
trio1.mother.Dovetail
trio1.mother.Maison
trio1.offspring.Arima
trio1.offspring.Dovetail
trio1.offspring.Maison-minus
trio1.offspring.Maison-plus
trio1.offspring.Phase
trio2.father.Maison
trio2.mother.Maison
trio2.offspring.Maison
```

I had to create these directory :
```bash
for dir in $(cat directory_to_create.txt)
do
  mkdir ~/work/polledHiC/data/reads/$dir
done
```

Next step is to create symbolic link between data and new directory. 
[SCRIPT IN COMMING]


## Meeting at 11:00 AM :

Fix objectives to Monday :

* Finish to prepare data directory.
* Analyze the first output from test data.
* Prepare a presentation of different output.
* Prepare a presentation of different informations from MultiQC rapport.