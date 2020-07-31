

# Premier bilan HiC-Explorer

Cette première étude permet de faire le bilan sur les différentes étapes ayant permis l'analyse de l’individu Offspring.

## Étape 1 : Conversion raw_matrix -> h5_matrix

Les raw matrices issue du nextflow ne sont pas exploitables tels quels, il est nécessaire de les convertir au format h5.

```bash
# Creation du repertoire de sortie
mkdir -p trio1.offspring.Maison-plus/hic_results/matrix/h5df

# Conversion des matrices
for matrices in trio1.offspring.Maison-plus/hic_results/matrix/raw/*.matrix
do
  bedfile=${matrices%.matrix}_abs.bed
  outname=${matrices##*trio1.offspring.}
  hicConvertFormat --matrices $mat --outFileName trio1.offspring.Maison-plus/hic_results/matrix/h5df/$outname --bedFileHicpro $bedfile --inputFormat hicpro --outputFormat h5
done
```

## Étape 2 : Somme des matrices 

### Somme de tous les protocoles de l'individus :

```bash
# Liste des differentes resolutions
resolutions="1000000.matrix.h5 500000.matrix.h5 200000.matrix.h5 50000.matrix.h5"

# Creation d'un repertoire de sortie
mkdir -p hic_050820

# Somme de tous les protocoles à chaque resolutions
for res in $resolutions 
do
  paths=''
  for mat in $(ls trio1.offspring.*/hic_results/matrix/h5df/*.h5)
  do
    if [[ $mat =~ $res ]] ; then
      paths+="$workdir/$mat "
    fi
  done
  hicSumMatrices --matrices $paths --outFileName hic_050820/OFFSPRING_$res
done
```

### Somme d'un protocole : Maison-plus

```bash
# Somme des runs du protocole Maison-plus
for res in $resolutions 
do
  paths=''
  for mat in $(ls trio1.offspring.Maison-plus/hic_results/matrix/h5df/*.h5)
  do
    if [[ $mat =~ $res ]] ; then
      paths+="$workdir/$mat "
    fi
  done
  hicSumMatrices --matrices $paths --outFileName hic_050820/OFFSPRING_Maison-plus_$res
done
```

### Somme d'un protocole : Dovetail

```bash
# Somme des runs du protocole Dovetail
for res in $resolutions 
do
  paths=''
  for mat in $(ls trio1.offspring.Dovetail/hic_results/matrix/h5df/*.h5)
  do
    if [[ $mat =~ $res ]] ; then
      paths+="$workdir/$mat "
    fi
  done
  hicSumMatrices --matrices $paths --outFileName hic_050820/OFFSPRING_Dovetail_$res
done
```

## Étape 3 : Diagnostic plot

```bash
# Diagnostic plot des matrices sommée
for matrices in hic_050820/*.h5
do
  hicCorrectMatrix diagnostic_plot -m $matrices -o ${matrices%.matrix.h5}.png
done
```

### Diagnostic plot : OFFSPRING_1000000

![offspring_1000000](.fig/bilan-050820/OFFSPRING_1000000.png)

On observe pas de Gaussienne

### Diagnostic plot protocoles : OFFSPRING_100000 

![offspring_Maison+_100000](.fig/bilan-050820/OFFSPRING_Maison-plus_Dovetail_1000000.png)

On observe pas de Gaussienne et un décalage de l'histogramme vers la gauche.

### Diagnostic plot : OFFSPRING_500000

![offspring_500000](.fig/bilan-050820/OFFSPRING_500000.png)

On observe pas de Gaussienne

### Diagnostic plot protocoles : OFFSPRING_500000 

![offspring_Maison+_500000](.fig/bilan-050820/OFFSPRING_Maison-plus_Dovetail_500000.png)

On observe pas de Gaussienne 'propre', mais on observe un décalage vers la gauche.

### Diagnostic plot : OFFSPRING_200000

![offspring_200000](.fig/bilan-050820/OFFSPRING_200000.png)

On commence a observer la Gaussienne

### Diagnostic plot protocoles : OFFSPRING_200000 

![offspring_Maison+_200000](.fig/bilan-050820/OFFSPRING_Maison-plus_Dovetail_200000.png)

On observe une Gaussienne décalé vers la gauche avec un pic de fréquence à 0 'total count per bins' moins élevés.

### Diagnostic plot : OFFSPRING_50000

![offspring_50000](.fig/bilan-050820/OFFSPRING_50000.png)

On observe une belle Gaussienne

### Diagnostic plot protocoles : OFFSPRING_50000 

![offspring_Maison+_50000](.fig/bilan-050820/OFFSPRING_Maison-plus_Dovetail_50000.png)

On observe une belle Gaussienne décalé vers la gauche avec un pic de fréquence à 0 'total count per bins' moins élevés.

### Différence Protocoles / Somme des protocoles 

On observe qu'en sommant les protocoles d'un individus, on retrouve des gaussienne mieux définie avec un décalage vers la droite. La différence entre un protocole riche en information (Maison-plus) et moins riches (Dovetail) est un décalage de cette gaussienne vers la gauche.

Ce décalage semble cohérent, moins on a d'informations, moins le 'total counts per bin' sera élevée. En sommant les matrices, on augmente la quantité d'informations disponible ce qui entraîne un décalage vers la droite.

## Étape 4 : Normalisation KR

Au vu des diagnostic plot, il est préférable de se concentrer uniquement sur les résolutions 200k et 50k bins.

Les diagnostics plots permettent d'établir un filterThreshold de -1.5 à 5.

```bash
# Listes des matrices d'interêt
matrices="OFFSPRING_200000.matrix.h5 OFFSPRING_50000.matrix.h5"

for mat in $matrices
do
  for m in hic_050820/*.h5
  do
    if [[ $m =~ $mat ]] ; then
      hicCorrectMatrix correct -m $m -o ${m%.matrix.h5}.corrected_matrix.h5 -t -1.5 5
    fi
  done
done
```

### Étude de diagnostic plot : avant / après normalisation

#### 200k bins resolutions :

```bash
hicCorrectMatrix diagnostic_plot -m hic_050820/OFFSPRING_200000.corrected_matrix.h5 -o hic_050820/OFFSPRING_200000.corrected.png
```

![offspring_200k_un/cor](.fig/bilan-050820/OFFSPRING_200k_un-cor.png)

#### 50k bins resolutions :

```bash
hicCorrectMatrix diagnostic_plot -m hic_050820/OFFSPRING_50000.corrected_matrix.h5 -o hic_050820/OFFSPRING_50000.corrected.png
```

![offspring_50k_un/cor](.fig/bilan-050820/OFFSPRING_50k_un-cor.png)


// TODO : Conclure sur l'impact de la normalisation

## Étape 5 : Carte chromosomique de la region

Dans le mail de Alain, l'ensemble des mutations portés sur le chromosome 1 ce situe entre les positions 2200000 et 2800000.

Pour étudier la présence ou non de raprochement, il sera plotter les regions suivantes :

* chromosome 1 en entier
* chromosome 1 : 1M-6M
* chromosome 1 : 1M5-3M5

Ces cartes seront plotter uniquement sur la résolutions 50k bins, avant et après normalisations.

### Chromosome 1 : full length

```bash
# Non-normalized
hicPlotMatrix -m hic_050820/OFFSPRING_50000.matrix.h5 -o hic_050820/50k_full_length.png --chromosomeOrder 1 --log

# Normalized
hicPlotMatrix -m hic_050820/OFFSPRING_50000.corrected_matrix.h5 -o hic_050820/50k_full_length.corrected.png --chromosomeOrder 1 --log
```

![chr1_full](.fig/bilan-050820/OFFSPRING_chr1_full.png)

### Chromosome 1 : 1M - 6M

```bash
# Non-normalized
hicPlotMatrix -m hic_050820/OFFSPRING_50000.matrix.h5 -o hic_050820/50k_1M_6M.png --region 1:1000000-6000000 --log

# Normalized
hicPlotMatrix -m hic_050820/OFFSPRING_50000.corrected_matrix.h5 -o hic_050820/50k_1M_6M.corrected.png --region 1:1000000-6000000 --log
```

![chr1_1m-6m](.fig/bilan-050820/OFFSPRING_chr1_1M-6M.png)

### Chromosome 1 : 1.5M - 3.5M

```bash
# Non-normalized
hicPlotMatrix -m hic_050820/OFFSPRING_50000.matrix.h5 -o hic_050820/50k_1M5_3M5.png --region 1:1500000-3500000 --log

# Normalized
hicPlotMatrix -m hic_050820/OFFSPRING_50000.corrected_matrix.h5 -o hic_050820/50k_1M5_3M5.corrected.png --region 1:1500000-3500000 --log
```

![chr1_1m5-3m5](.fig/bilan-050820/OFFSPRING_chr1_1M5-3M5.png)

### Chromosome 1 : 2M - 3M

```bash
# Non-normalized
hicPlotMatrix -m hic_050820/OFFSPRING_50000.matrix.h5 -o hic_050820/50k_2M_3M.png --region 1:2000000-3000000 --log

# Normalized
hicPlotMatrix -m hic_050820/OFFSPRING_50000.corrected_matrix.h5 -o hic_050820/50k_2M_3M.corrected.png --region 1:2000000-3000000 --log
```

![chr1_2m-3m](.fig/bilan-050820/OFFSPRING_chr1_2M-3M.png)

