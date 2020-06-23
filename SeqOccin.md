
### SeqOccin HiC data 

- Two bovine trios 
    - different HiC protocols (Arima, Dovetail, PhaseG and home-made)
    - different runs with different coverage
 
 Location on genologin (front server of the genotoul plateform): 
 ```
 /work2/project/seqoccin/data/reads/hic/bos_taurus
 ```

#### Available HiC data in SeqOccin

| trio | animal | run | protocol | reads |
| ------------- | ------------- |  ------------- | ------------- | ------------- |
| trio1 | father | run1 | Arima | 179275634 |
| trio1 | father | run1 | Dovetail | 7400016 |
| trio1 | father | run1 | Maison | 283750312 |
| trio1 | father | run1 | PhaseG | 9902604 |
| trio1 | father | run2 | Arima | 239664766 |
| trio1 | mother | run1 | Arima | 152733036 |
| trio1 | mother | run1 | Dovetail | 216646824 |
| trio1 | mother | run1 | Maison | 268476244 |
| trio1 | mother | run2 | Arima | 210968986 |
| trio1 | offspring | run1 | Arima | 3376278 |
| trio1 | offspring | run1 | Dovetail | 2992298 |
| trio1 | offspring | run1 | Maison-minus | 3083146 |
| trio1 | offspring | run1 | Maison-plus | 3431440 |
| trio1 | offspring | run1 | Phase | 3461138 |
| trio1 | offspring | run2 | Arima | 260682990 |
| trio1 | offspring | run2 | Dovetail | 328489852 |
| trio1 | offspring | run2 | Maison-plus | 135487330 |
| trio1 | offspring | run3 | Maison-plus | 376689540 |
| trio2 | father | run1 | Maison | 256081786 |
| trio2 | father | run2 | Maison | 200030592 |
| trio2 | mother | run1 | Maison | 319727754 |
| trio2 | mother | run2 | Maison | 227701398 |
| trio2 | offspring | run1 | Maison | 282425964 |
| trio2 | offspring | run2 | Maison | 215786704 |

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


