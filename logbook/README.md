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
	* [Download genome file](#download-genome-file-)
	* [All-In-One script](#all-in-one-script-)
* [2020-07-03](#2020-07-03)
	* [Analyze of output files](#analyze-of-output-files-)
		* [Contact map](#contact-map-)
		* [MultiQC report](#multiqc-report-)

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

Next step was to create symbolic link between data and new directory. To realize this, I design a small script that I put on `~/work/polledHiC/data/` :

```bash
#!/bin/bash

readsdir=/work2/project/seqoccin/data/reads/hic/bos_taurus
datadir=/home/jmartin/work/polledHiC/data/reads

for file in $(cat list_file.txt)
do
  subdir=$(echo ${file%%_*} | sed 's/.run*.//g')
  ln -s $readsdir/$file $datadir/$subdir/$file
done
```

## Meeting at 11:00 AM :

Fix objectives to Monday :

* Finish to prepare data directory.
* Analyze the first output from test data.
* Prepare a presentation of different output.
* Prepare a presentation of different informations from MultiQC rapport.

## Download genome file :

Genome fasta file is downloaded thank's to `wget` :

```bash
# Set working directory
cd ~/work/polledHiC/data/genome

# Download with wget
wget ftp://ftp.ensembl.org/pub/release-100/fasta/bos_taurus/dna/Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.fa.gz

# Decompress (gzip archive aren't compatible with Samtools faidx)
gzip -d Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.fa.gz
```

When all it's done, I had to index the genome file :
```bash
module load bioinfo/samtools-1.10
samtools faidx Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.fa

module load bioinfo/bowtie2-2.3.5.1
bowtie2-build Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.fa Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.bt
```

Everything is ready now to start the analyzes on Monday.

## All-In-One script :

Because it's more user-friendly, I purpose here a All-In-One script to automate all the previous step. I reached to group two step in one here : I control the creation of subdirectory at same time I create symbolic link. I named it as `exportData.sh` and it's on `~/work/polledHiC/data/.`

```bash
#!/bin/bash

# Environment preparation
echo "Environment Preparation"
echo -n "-" ; sleep 0.2 ; echo -n "-" ; sleep 0.2 ; echo "-"
readsdir=/work2/project/seqoccin/data/reads/hic/bos_taurus
datadir=/home/jmartin/work/polledHiC/data/reads
genome=/home/jmartin/work/
echo "Environment OK"

# List of read files
echo "Acquisition of reads files"
echo -n "-" ; sleep 0.2 ; echo -n "-" ; sleep 0.2 ; echo "-"
list_file=$(ls $readsdir)

# Creation of subdirectories and symbolic links
echo "Creation of subdirectories and symbolic links"
echo -n "-" ; sleep 0.2 ; echo -n "-" ; sleep 0.2 ; echo "-"
for file in $list_file
do
  subdir=$(echo ${file%%_*} | sed 's/.run*.//g')
  if [ -d $datadir/$subdir ]; then
  	ln -s $readsdir/$file $datadir/$subdir/$file
  else
  	mkdir -p $datadir/$subdir
  	echo "Creation of $subdir"
  	ln -s $readsdir/$file $datadir/$subdir/$file
  fi
done

echo "Export reads data finished !"
sleep 2

# Export Genome data
echo "Start exporting Genome data"
echo -n "-" ; sleep 0.2 ; echo -n "-" ; sleep 0.2 ; echo "-"

cd genome/

wget ftp://ftp.ensembl.org/pub/release-100/fasta/bos_taurus/dna/Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.fa.gz
echo "Start decompress archive"
echo -n "-" ; sleep 0.2 ; echo -n "-" ; sleep 0.2 ; echo "-"
gzip -d Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.fa.gz
echo "Decompress SUCCESS"

echo "Writting sbatch script"
echo -n "-" ; sleep 0.2 ; echo -n "-" ; sleep 0.2 ; echo "-"
echo "#!/bin/bash
#SBATCH -J "index_genome"
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH -p workq
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --export=ALL

module purge
module load bioinfo/samtools-1.10
module load bioinfo/bowtie2-2.3.5.1

samtools faidx Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.fa

bowtie2-build Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.fa Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.bt " > indexing_script.sh
echo "SBATCH Script written \n"

# Then
echo "Submit sbatch query"
echo -n "-" ; sleep 0.2 ; echo -n "-" ; sleep 0.2 ; echo "-"
sbatch indexing_script.sh
```

# 2020-07-03

## Analyze of output files :

On test dataset, pipeline return us lot of different results. I purpose to focus us on some of them :

* Contact map (`[...]/nfcorehic/hic_results/matrix`) : contains several matrix of contact mapping at different resolutions.
* MultiQC report give us many statistical informations, including :
	* alignment statistics (`[...]/nfcorehic/mapping/stats/trio1.offspring.run1.Maison-plus_GACGTC-CDFVM_L001_bwt2pairs.pairstat`)
	* pairing statistics (`[...]/nfcorehic/hic_results/stats/.../trio1.offspring.run1.Maison-plus_GACGTC-CDFVM_L001.mRSstat`)

### Contact map :

A contact map is defined by :

* A list of genomic intervals related to the specified resolution (--in-size argument of nfcore pipeline) = BED FORMAT.
* A matrix, stored as standard triplet sparse format = .tsv FORMAT.

For instance, here is a presentation at the lowest resolutions :

**Bed file :**

| Chrom_ID       	| Start   	| End     	| Name 	|
|----------------	|---------	|---------	|------	|
| 1              	| 0       	| 1000000 	| 1    	|
| 1              	| 1000000 	| 2000000 	| 2    	|
| 1              	| 2000000 	| 3000000 	| 3    	|
| ...            	| ...     	| ...     	| ...  	|
| NKLS02002208.1 	| 8000000 	| 9000000 	| 4833 	|
| NKLS02002208.1 	| 9000000 	| 9309904 	| 4834 	|
| NKLS02002209.1 	| 0       	| 27572   	| 4835 	|

**Matrix :**

| Read1 	| Read2 	| Counts? 	|
|-------	|-------	|--------	|
| 1     	| 1     	| 40     	|
| 1     	| 2     	| 12     	|
| 1     	| 4     	| 4      	|
| ...   	| ...   	| ...    	|
| 4836  	| 4836  	| 80     	|
| 4837  	| 4837  	| 3      	|

To be used to create image map, this matrix need to be transformed in HDF5 format. This format is a complex compressed format structured as :
```
── matrix [HDF5 group]
    ├── barcodes
    ├── data
    ├── indices
    ├── indptr
    ├── shape
    └── features [HDF5 group]
        ├─ _all_tag_keys
        ├─ feature_type
        ├─ genome
        ├─ id
        ├─ name
        ├─ pattern [Feature Barcoding only]
        ├─ read [Feature Barcoding only]
        └─ sequence [Feature Barcoding only]
```

### MultiQC report :

MultiQC report provides us lots of statistical informations. A great advantage from MultiQC is that return all of these as clearly graph.

**Read Mapping :**

![Mapping Statistics](/home/jmartin/work/polledHiC/logbook/.fig/MultiQC_test/hicpro_mapping_stats_plot-1.png)

> Full reads Alignments: 67.2%
> Trimmed reads Alignments: 28.9%
> Failed to Align: 3.9%

// TODO
This part describes the alignment of reads in single-end mode.

**Read Pairing :**

![Pairing Statistics](/home/jmartin/work/polledHiC/logbook/.fig/MultiQC_test/hicpro_pairing_stats_plot-1.png)

> Uniquely Aligned: 65.8%
> Low Quality: 23.3%
> Singleton: 10.9%

// TODO

**Read Pair Filtering :**

![Filtering Statistics](/home/jmartin/work/polledHiC/logbook/.fig/MultiQC_test/hicpro_filtering_plot-1.png)

> Valid Pairs FF: 21.8%
> Valid Pairs RR: 21.8%
> Valid Pairs RF: 21.5%
> Valid Pairs FR: 22.3%
> Same Fragment - Same Circle: 0.3%
> Same Fragment - Danglging Ends: 8.1%
> Re-ligation: 0.8%
> Filtered pairs: 3.5%
> Dumped pairs: 0.0%

// TODO

**Contact Statistics :**

![Contact Statistics](/home/jmartin/work/polledHiC/logbook/.fig/MultiQC_test/hicpro_contact_plot-1.png)

> Unique: cis <=20Kbp: 5.9%
> Unique: cis > 20Kbp: 49.8%
> Unique: trans: 44.2%
> Duplicate read pairs: 0.0%

// TODO