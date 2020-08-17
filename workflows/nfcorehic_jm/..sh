#!/bin/bash
#SBATCH -J nfcorehic-.
#SBATCH -e /work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm/./nfcorehic-..err
#SBATCH -o /work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm/./nfcorehic-..log
#SBATCH -p workq
#SBATCH --mail-type=END,FAIL
#SBATCH --export=ALL
#SBATCH --cpus-per-task=1
#SBATCH --mem=12G

module purge
module load bioinfo/nfcore-Nextflow-v19.04.0

# creation outdir
mkdir -p /work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm/.
cd /work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm/.

# most are default options - skipping ICE because normalizing
each technical replicate is not relevant
nextflow run nf-core/hic \
 -revision    1.1.0 \
 -profile     genotoul \
 -name      nfcorehic-. \
 -c '/home/sfoissac/work/.nextflow/mount.conf' \
 -c '/work2/genphyse/dynagen/jmartin/polledHiC/work/bt2_end2end.config' \
 --fasta      /bank/bowtie2db/ensembl_bos_taurus_genome \
 --bwt2_index /bank/bowtie2db/ensembl_bos_taurus_genome \
 --outdir     /work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm/. \
 --work-dir   /work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm/. \
 -resume \
 --reads      '/work2/genphyse/dynagen/jmartin/polledHiC/data/reads_nfcore/./*_R{1,2}.fastq.gz' \
 --bwt2_opts_end2end '--very-sensitive -L 30 --score-min L,-0.6,-0.2 --end-to-end --reorder' \
 --bwt2_opts_trimmed '--very-sensitive -L 20 --score-min L,-0.6,-0.2 --end-to-end --reorder' \
 --min_mapq 10 \
 --restriction_site  '' \
 --ligation_site     '' \
 --chromosome_size /work2/genphyse/dynagen/jmartin/polledHiC/data/genome/chrom.len \
 --min_insert_size 20 \
 --max_insert_size 1000 \
 --rm_singleton \
 --rm_dup \
 --bin_size                  '200000,50000,25000,10000' \
 --ice_max_iter     100 \
 --ice_filer_low_count_perc  0.02 \
 --ice_filer_high_count_perc 0 \
 --ice_eps     0.1 \
 --skipIce\
 --skipCool
 --clean -f -k
