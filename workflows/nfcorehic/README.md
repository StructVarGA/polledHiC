

# Installation
# Conda env for hic pipeline

```
conda create -n hicpipe
conda activate hicpipe
conda install snakemake
pip install drmaa
```

# Usage

```
conda activate hicpipe
```

```
snakemake --jobs 2 -p -n
```

## Init units.tsv

```python
import glob

list_reads_dir = glob.glob('/work2/genphyse/dynagen/jmartin/polledHiC/data/reads_nextflow/*')

list_reads_dir.sort()

with open('units.tsv', 'w') as fh:
   print('sample', 'protocol', 'fastqdir', sep = "\t", file = fh)
   for fastqdir in list_reads_dir:
     sample = '.'.join(fastqdir.split('/')[-1].split('.')[:2])
     protocol = fastqdir.split('/')[-1].split('.')[2]
     print(sample, protocol, fastqdir, sep = "\t", file = fh)
```
