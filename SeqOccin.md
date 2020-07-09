
### SeqOccin HiC data 

- Two bovine trios 
    - different HiC protocols (Arima, Dovetail, PhaseG and home-made)
    - different runs with different coverage
 
 Location on genologin (front server of the genotoul plateform): 
 ```
 /work2/project/seqoccin/data/reads/hic/bos_taurus
 ```

#### Available HiC data in SeqOccin

| trio | animal | run | protocol | paired reads |
| ------------- | ------------- |  ------------- | ------------- | ------------- |
| trio1 | father | run1 | Arima | 89637817 |
| trio1 | father | run1 | Dovetail | 3700008 |
| trio1 | father | run1 | Maison | 141875156 |
| trio1 | father | run1 | PhaseG | 4951302 |
| trio1 | father | run2 | Arima | 119832383 |
| trio1 | mother | run1 | Arima | 76366518 |
| trio1 | mother | run1 | Dovetail | 108323412 |
| trio1 | mother | run1 | Maison | 134238122 |
| trio1 | mother | run2 | Arima | 105484493 |
| trio1 | offspring | run1 | Arima | 1688139 |
| trio1 | offspring | run1 | Dovetail | 1496149 |
| trio1 | offspring | run1 | Maison-minus | 1541573 |
| trio1 | offspring | run1 | Maison-plus | 1715720 |
| trio1 | offspring | run1 | Phase | 1730569 |
| trio1 | offspring | run2 | Arima | 130341495 |
| trio1 | offspring | run2 | Dovetail | 164244926 |
| trio1 | offspring | run2 | Maison-plus | 67743665 |
| trio1 | offspring | run3 | Maison-plus | 188344770 |
| trio2 | father | run1 | Maison | 128040893 |
| trio2 | father | run2 | Maison | 100015296 |
| trio2 | mother | run1 | Maison | 159863877 |
| trio2 | mother | run2 | Maison | 113850699 |
| trio2 | offspring | run1 | Maison | 141212982 |
| trio2 | offspring | run2 | Maison | 107893352 |


#### Script to generate HiC data stats

```bash
datadir=/work2/project/seqoccin/data/reads/hic/bos_taurus
printf "| trio | animal | run | protocol | paired reads |\n" > tmp_stats.txt
printf "| ------------- | ------------- |  ------------- | ------------- | ------------- |\n" >> tmp_stats.txt
for file in `ls $datadir/*R1.fastq.gz`;  
 do   
   base=`basename $file`;   
   name=`echo $base | awk '{ split($1,a,"_"); print a[1]}'`;   
   numlines=`zcat $file  | wc -l | awk '{ print $1/4}'`;   
   printf "| %s | %s |\n" $name $numlines | sed 's/\./ | /g'; 
 done >> tmp_stats.txt
```


