
### HiC protocols

The HiC analyiss pipeline requires information about restriction motif and ligation motif :
  - **restriction site** : where the restriction enzime cuts the DNA
  - **ligation motif** : how the fill-in procedure fills the gap and introduces biotin

biinformatic pipeline use these information in the following manner
  - **restriction motif** : to find restriction site on the reference genome. At least one restriction site must separate the two reads
  - **ligation motif** : when reads are split possibily because it runs through a ligation site, the ligation motif must be found

### Restriction and ligation site : example of the Dovetail protocol

![Test image](https://github.com/StructVarGA/polledHiC/blob/master/pics/fill_in.jpg)

### Restriction and ligation site : example of a protocol with hindIII figure 1b in 

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4706059/

The restriction motif and ligation mtif differs between protocols :

### Arima

```

```




