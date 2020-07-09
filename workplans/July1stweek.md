
First steps with the HiC pipeline ([HiC pipeline](../pipeline.md))

1. Create a working directory in your work : polledHiC
2. Copy in this directory, the following dir 
```
/work2/genphyse/dynagen/tfaraut/polledHiC/data
```
3. Create a working directory for the first pipeline test (I used ~/work/polledHiC/work/test)
4. Copy the following README.sh file in this working dir
```
/work2/genphyse/dynagen/tfaraut/polledHiC/work/test/README.sh
```
5. Make appropriate changes to this README (wdir and datadir)
6. You are now ready to launch the HiC pipeline on this small dataset
7. Have a look at the different output files  

**Bonus** If all this is done, you can also produce the first HiC map  
4. Install HiCExplorer using conda: https://hicexplorer.readthedocs.io/en/latest/content/installation.html  
5. Reformat the matrix format in h5 (https://hicexplorer.readthedocs.io/en/latest/content/tools/hicConvertFormat.html)  
6. Construct the HiC contact map (using hicPlotMatrix)  

