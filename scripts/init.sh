datadir=   # path to reads directory i.e. ~/polledHiC/data/reads
wdir=   # path to work directory i.e. ~/polledHiC/work
genome=   # path to genome directory i.e. ~/polledHiC/data/genome
chromsize=   # a tsv file with chromosome length : chr_id length, one line per chromosome

echo '' > $pathscript

for trio in $(ls $datadir)
do
  mkdir -p $wdir/$trio
done

cd $wdir

for run in $(ls -d trio*/ | sed 's/\///g')
do
  # Set parametres
  runid=nfcorehic-$run
  outdir=$wdir/$run
  script=$outdir/$runid.sh
  readsdir=$datadir/$run
  log=$outdir/$runid.log
  err=$outdir/$runid.err
  
  # Set restriction/ligation parametres
  case $run in
    *Arima) restriction='^GATC,G^ANTC'
            ligation='GATCGATC,GANTGATC,GANTANTC,GATCANTC'
            echo "run Arima : $run
            res : $restriction
            lig : $ligation";;
    *Dovetail) restriction='^GATC'
            ligation='GATCGATC'
            echo "run Dovetail : $run
            res : $restriction
            lig : $ligation";;
    *Maison*) restriction='A^AGCTT'
            ligation='AAGCTAGCTT'
            echo "run Maison-* : $run
            res : $restriction
            lig : $ligation";;
    *Phase*) restriction='NR' 
            ligation='NR'
            echo "run Phase* : restriction et ligation non renseigné - $run
            res : $restriction
            lig : $ligation";;
    *test*) restriction='A^AGCTT'
            ligation='AAGCTAGCTT'
            echo "run test : $run
            res : $restriction
            lig : $ligation";;
  esac
  
  # Creation of '$outdir'
  mkdir -p $outdir
  cd $outdir
  
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
 -c '"'"'/home/sfoissac/work/.nextflow/mount.conf'"'"' \
 -c '"'"'/home/jmartin/work/polledHiC/work/bt2_end2end.config'"'"' \
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
 --bin_size                  '"'"'1000000,500000,200000,50000'"'"' \
 --ice_max_iter     100 \
 --ice_filer_low_count_perc  0.02 \
 --ice_filer_high_count_perc 0 \
 --ice_eps     0.1 \
 --skipIce\
 --skipCool' > $script

  # and finally
  echo $script >> $pathscript
done
