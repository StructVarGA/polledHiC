


# Installation
# Conda env for hicexplorer
```
## hicexplorer and snakemake
conda create -n hicexplorerenv
conda activate hicexplorerenv
conda install hicexplorer -c bioconda -c conda-forge
conda install snakemake
pip install drmaa
```

# Usage
```
conda activate hicexplorer3env
```

```
snakemake --jobs 4 -p -n
```
When lauching snakemake on a node, the number of necessary (requested) cpus is related to the number of jobs and of cpus for each job (e.g for hicexplorer)

# Init sampled_protocols.tsv

```python
import os
import glob

nfcore_dir = glob.glob('/work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm/*/')

tsv = []
for prot in nfcore_dir:
   path = prot + 'hic_results/matrix/raw/*.matrix'
   for mat in glob.glob(path):
     sample = '.'.join(mat.split('/')[-1].split('.')[:2])
     protocol = mat.split('/')[-1].split('.')[-2].split('_')[0]
     matrixdir = '/'.join(mat.split('/')[:-1])
     line = sample + "\t" + protocol + "\t" +matrixdir
     if line not in tsv:
        tsv.append(line)

tsv.sort()
with open('sampled_protocols.tsv', 'w') as fh:
   print('sample', 'protocol', 'matrixdir', sep="\t", file = fh)
   for l in tsv:
      print(l, file = fh)
```
