
#### Using modules on genologin

Many software are not available by default on the cluster (and front server).  
For example if you need to used samtools, you have first to load a module
```
module load bioinfo/samtools-1.10
```

The available module can be found using 
```
module avail
```
But the most efficient way to find a module is using the searc_module command, for example
```
search_module samtools
```
A new paradigm for installing software is to wrap the installation within a virtual environment.  
Python when only python modules have to be installed, conda if other sofwtares (C++ coded for example) have to ne installed.  
For the installation of HiCExplorer, we recommend to create first a conda virtual env.
```
module load system/Miniconda3-4.7.10
conda create -n hicexploenv python=3.6
conda activate hicexploenv
```
(you might have to use conda init to make it work, follow the instructions).  
You are now ready to install HiCExplorer following the instructions : https://hicexplorer.readthedocs.io/en/latest/content/installation.html
