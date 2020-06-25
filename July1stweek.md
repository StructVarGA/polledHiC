
1. Create a working directory in your work : polledHiC
2. Create a data directory hierarchy as follows
```
├── polledHiC
│   ├── data
|   |    ├── trio1.mother.protocolA
|   |    ├── trio1.mother.protocolB
|   |    ├── trio1.offspring.protocolA
|   |    └── ...
│   └── genome
```
  - data subdir  
  The data dir contains for each (trio,indiv,hic_protocol) symbolic links to Hic fastq files of the seqoccin hic repository datadir :
 ```
 datadir=/work2/project/seqoccin/data/reads/hic/bos_taurus
 ```
  For example, the trio2.offspring.Maison subdirectory should contain the folowing links :
 ```
trio2.offspring.run1.Maison_GACCTGAA-TTGGTGAG-BHHNMLDRXX_L001_R1.fastq.gz -> /home/faraut/seqoccin/data/reads/hic/bos_taurus/trio2.offspring.run1.Maison_GACCTGAA-TTGGTGAG-BHHNMLDRXX_L001_R1.fastq.gz
trio2.offspring.run1.Maison_GACCTGAA-TTGGTGAG-BHHNMLDRXX_L001_R2.fastq.gz -> /home/faraut/seqoccin/data/reads/hic/bos_taurus/trio2.offspring.run1.Maison_GACCTGAA-TTGGTGAG-BHHNMLDRXX_L001_R2.fastq.gz
trio2.offspring.run2.Maison_GACCTGAA-CTCACCAA-AHGCCLBBXY_L007_R1.fastq.gz -> /home/faraut/seqoccin/data/reads/hic/bos_taurus/trio2.offspring.run2.Maison_GACCTGAA-CTCACCAA-AHGCCLBBXY_L007_R1.fastq.gz
trio2.offspring.run2.Maison_GACCTGAA-CTCACCAA-AHGCCLBBXY_L007_R2.fastq.gz -> /home/faraut/seqoccin/data/reads/hic/bos_taurus/trio2.offspring.run2.Maison_GACCTGAA-CTCACCAA-AHGCCLBBXY_L007_R2.fastq.gz 
```
This can be done programmaticaly.

   - genome dir  
   The genome dir contains the bovine reference assembly genome sequence (ARS-UCD1.2) : 
```
    ftp://ftp.ensembl.org/pub/release-100/fasta/bos_taurus/dna/Bos_taurus.ARS-UCD1.2.dna_sm.toplevel.fa.gz
```  
* Download the genome sequence
* Index the genome sequence with samtools faidx. You will need to load the correct module on genologin, use
  ```
  search_module samtools
  ```
  and for exemple select the most recent version, then load
  ```
  module load bioinfo/samtools-1.10
  ```
* Index the genome sequence fasta sequence with bowtie2. Again find the module to load
  ```
  search_module bowtie2
  ```
  See paragraph "Building a new index" here http://bowtie-bio.sourceforge.net/tutorial.shtml

Now everything is ready to try the [HiC pipeline](pipeline.md) 

First test on a small data set. Make a subdirectory in the data/reads dir
```
mkdir data/reads/test
```
For example reads from the trio1.offspring.run1.Maison
Again, make symbolic links to the fastq files
```
trio1.offspring.run1.Maison-plus_GACGTC-CDFVM_L001_R1.fastq.gz -> /home/faraut/seqoccin/data/reads/hic/bos_taurus/trio1.offspring.run1.Maison-plus_GACGTC-CDFVM_L001_R1.fastq.gz
trio1.offspring.run1.Maison-plus_GACGTC-CDFVM_L001_R2.fastq.gz -> /home/faraut/seqoccin/data/reads/hic/bos_taurus/trio1.offspring.run1.Maison-plus_GACGTC-CDFVM_L001_R2.fastq.gz
```

