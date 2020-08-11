

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
