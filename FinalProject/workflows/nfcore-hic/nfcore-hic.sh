#!/bin/bash

# Set parametres :

datadir= # path/to/reads_directories i.e. : /work2/genphyse/dynagen/jmartin/polledHiC/data/reads_nfcore

wdir= # path/to/working_directory i.e. : /work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm

genome= # path/to/genomic_bank i.e. : /bank/bowtie2db/ensembl_bos_taurus_genome

chromsize= # path/to/chrom.lengh file i.e. : /work2/genphyse/dynagen/jmartin/polledHiC/data/genome/chrom.len

# Init working directory :

for prot in $(ls $datadir)
do
  mkdir -p $wdir/$prot
done

cd $wdir

for prot in $(ls -d */ | sed 's/\///g')
do
  # Get parametres
  runid=nfcorehic-$prot
  outdir=$wdir/$prot
  script=$outdir/$prot.sh
  readsdir=$datadir/$prot
  log=$outdir/$runid.log
  err=$outdir/$runid.err
  conf=$wdir/nfcore-hic.config
  
  # Set restriction/ligation parametres
  case $prot in
    *[protocol]) restriction= # restriction fragment as following : '^GATC,G^ANTC'
            ligation= # ligation fragment as following : 'GATCGATC,GANTGATC,GANTANTC,GATCANTC'
            echo "run [protocol] : $run
            res : $restriction
            lig : $ligation";;
    *) restriction='not recognized'
            ligation='not recognized'
            echo "run NOT RECOGNIZED : $run
            res : $restriction
            lig : $ligation";;

  esac
  
  echo '#!/bin/bash
#SBATCH -J '$runid'
#SBATCH -e '$err'
#SBATCH -o '$log'
#SBATCH -p workq
#SBATCH --mail-type=END,FAIL
#SBATCH --export=ALL
#SBATCH --cpus-per-task=1
#SBATCH --mem=12G

module purge
module load bioinfo/nfcore-Nextflow-v19.04.0

# creation outdir
mkdir -p '$outdir'
cd '$outdir'

# most are default options - skipping ICE because normalizing
each technical replicate is not relevant
nextflow run nf-core/hic \
 -revision    1.1.0 \
 -profile     genotoul \
 -name      '$runid' \
 -c '"'"$conf"'"' \
 --fasta      '$genome' \
 --bwt2_index '$genome' \
 --outdir     '$outdir' \
 --work-dir   '$outdir' \
 -resume \
 --reads      '"'"''$readsdir'/*_R{1,2}.fastq.gz'"'"' \
 --bwt2_opts_end2end '"'"'--very-sensitive -L 30 --score-min L,-0.6,-0.2 --end-to-end --reorder'"'"' \
 --bwt2_opts_trimmed '"'"'--very-sensitive -L 20 --score-min L,-0.6,-0.2 --end-to-end --reorder'"'"' \
 --min_mapq 10 \
 --restriction_site  '"'"$restriction"'"' \
 --ligation_site     '"'"$ligation"'"' \
 --chromosome_size '$chromsize' \
 --min_insert_size 20 \
 --max_insert_size 1000 \
 --rm_singleton \
 --rm_dup \
 --bin_size # remplace x,y,z as following : '"'"'x,y,z'"'"' \
 --ice_max_iter     100 \
 --ice_filer_low_count_perc  0.02 \
 --ice_filer_high_count_perc 0 \
 --ice_eps     0.1 \
 --skipIce\
 --skipCool' > $script
done 
