

# Premier bilan HiC-Explorer

Cette première étude permet de faire le bilan sur les différentes étapes ayant permis l'analyse de l'individus Offspring.

## Etape 1 : Conversion raw_matrix -> h5_matrix

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

## Etape 2 : Somme des matrices 

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

## Etape 3 : Diagnostic plot

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

On observe pas de Gaussienne et un décallage de l'histogramme vers la gauche.

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

### Difference Protocoles / Somme des protocoles 

On observe qu'en sommant les protocoles d'un individus, on retrouve des gaussienne mieux définie avec un décallage vers la droite. La différence entre un protocole riche en information (Maison-plus) et moins riches (Dovetail) est un décallage de cette gaussienne vers la gauche.

Ce décallage semble cohérent, moins on a d'informations, moins le 'total counts per bin' sera élevée. En sommant les matrices, on augmente la quantité d'informations disponible ce qui entraine un décallage vers la droite.

## Etape 4 : Normalization KR

Au vu des diagnostic plot, il est préférable de se concentrer uniquement sur les résolutions 200k et 50k bins.

Les diagnostics plots permettent d'établir un filterThreeshold de -1.5 à 5.



