
### HiC protocols

The HiC analysis pipeline requires information about restriction motif and ligation motif :
  - **restriction site** : where the restriction enzime cuts the DNA
  - **ligation motif** : how the fill-in procedure fills the gap and introduces biotin

The bionformatic pipeline uses these information in the following manner
  - **restriction motif** : to find restriction site on the reference genome. At least one restriction site must separate the two reads
  - **ligation motif** : when a read is split possibily because it runs through a ligation site, the ligation motif must be found

The different HiC protocols used different restriction ensymes associated with different fiil-in procedure.
See figure below for a description of the HiC Dovetail protocol.

3 HiC protocols will be used :

### Arima

```
restriction_site  ^GATC, G^ANTC 
ligation_site     GATCGATC, GANTGATC, GANTANTC, GATCANTC
```

###  Maison (plus or minus)

```
restriction_site  A^AGCTT
ligation_site     AAGCTAGCTT
```

### Dovetail

```
restriction_site  ^GATC
ligation_site    GATCGATC
```


### Restriction and ligation site : example of the Dovetail protocol

![Test image](https://github.com/StructVarGA/polledHiC/blob/master/pics/fill_in.jpg)

### Restriction and ligation site : example of a protocol with hindIII figure 1b in 

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4706059/

The restriction motif and ligation mtif differs between protocols :






