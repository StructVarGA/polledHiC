


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
