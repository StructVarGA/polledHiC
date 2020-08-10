```bash
# Convert matrix
protocols="Arima Maison-minus Maison-plus Dovetail"

for prot in $protocols
do
  mkdir -p trio1.offspring.$prot/matrix/h5df
  for mat in trio1.offspring.$prot/matrix/raw/*.matrix
  do
    bedfile=${mat%.matrix}_abs.bed
    outname=${mat##*trio1.offspring.}
    hicConvertFormat --matroces $mat --outFileName trio1.offspring.$prot/hic_results/matrix/h5df/$outname --bedFileHicpro $bedfile --outputFormat h5 --inputFormat hicpro
  done
done

# Sum matrices
resolutions="50000 20000 10000"

for res in $resolutions
do
  paths=''
  for mat in $(ls trio1.offspring.*/hic_results/matrix/h5df/*_$res.matrix.h5)
  do
    paths+="$mat "
  done
  hicSumMatrices --matrices $paths --outFileName hic_50_20_10k/Offspring_$res.matrix.h5
done

# Adjust matrix
for mat in hic_50_20_10k/*.h5
do
  hicAdjustMatrix --matrix $mat --outFileName ${mat/Offspring/Offspring_full_chr} --chromosomes 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 X --action keep
done

# Normalize
for mat in hic_50_20_10k/*.h5
do
  hicNormalize --matrices $mat --outFileName ${mat/Offspring/Offspring_Normalized} --normalize smallest
done

# Diagnostic plot
for mat in hic_50_20_10k/*.h5
do
  hicCorrectMatrix diagnostic_plot -m $mat -o ${mat%.matrix.h5}.png
done
```

| MATRIX            | Mad Threeshold |
|-------------------|----------------|
| 10000             | -1.8           |
| Normalized_10k    | -1.8           |
| Full_chr_10k      | -2             |
| Normalized_fc_10k | -2             |
| 20000             | -2.3           |
| Normalized_20k    | -2.3           |
| Full_chr_20k      | -2.6           |
| Normalized_fc_20k | -2.6           |
| 50000             | -3             |
| Normalized_50k    | -3             |
| Full_chr_50k      | -3.8           |
| Normalized_fc_50k | -3.8           |

```bash
# Correction
for mat in hic_50_20_10k/*.h5
do
  echo "Set mad threeshold for ${mat#*/} :"
  read mad
  hicCorrectMatrix correct -m $mat -t $mad 5 -o ${mat/matrix/corrected_matrix}
done

# Carte chromosomique
for mat in hic_50_20_10k/*.corrected_matrix.h5
do
  hicPlotMatrix -m $mat -o ${mat%.corrected_matrix.h5}_full_chr.png --chromosome 1 --log
  hicPlotMatrix -m $mat -o ${mat%.corrected_matrix.h5}_1M-6M.png --region 1:1000000-6000000 --log
  hicPlotMatrix -m $mat -o ${mat%.corrected_matrix.h5}_1M5-3M5.png --region 1:1500000-3500000 --log
  hicPlotMatrix -m $mat -o ${mat%.corrected_matrix.h5}_2M-3M.png --region 1:2000000-3000000 --log
  hicPlotMatrix -m $mat -o ${mat%.corrected_matrix.h5}_2M2-2M8.png --region 1:2200000-2800000 --log
done
```


