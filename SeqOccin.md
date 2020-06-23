
#### Available HiC data in SeqOccin

| trio | animal | run | protocol | run | reads |
| ------------- | ------------- |  ------------- | 
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

trio 1

| animal | protocol | run |
| ------------- | ------------- |  ------------- | 
| offspring  |  Arima | run1 |
| offspring  |  Arima | run2 |
| offspring  |  Dovetail | run1 |
| offspring  |  Dovetail | run2 |
| offspring  |  Phase | run1 |
| offspring  |  Maison-minus | run1 |
| offspring  |  Maison-minus | run2 |
| offspring  |  Maison-plus | run1 |
| offspring  |  Maison-plus | run2 |
| offspring  |  Maison-plus | run3 |
| mother  |  Arima | run1 |
| mother  |  Arima | run2 |
| mother  |  Dovetail | run1 |
| mother  |  Maison| run1 |
| father  |  Arima | run1 |
| father  |  Arima | run2 |
| father  |  Dovetail | run1 |
| father  |  Maison| run1 |
|  father  |  PhaseG| run1 |


trio 2

| animal | protocol | run |
| ------------- | ------------- |  ------------- | 
|  offspring  |  Maison| run1 |
| offspring  |  Maison| run2 |
| mother  |  Maison| run1 |
| mother  |  Maison| run2 |
| father  |  Maison| run1 |
| father  |  Maison| run2 |

#### Script to generate HiC data stats

```bash
datadir=/work2/project/seqoccin/data/reads/hic/bos_taurus
for file in `ls $datadir/*R1.fastq.gz`; 
do
  base=`basename $file`
  name=`echo $base | awk '{ split($1,a,"_"); print a[1]}'`
  numlines=`zcat $file  | wc -l | awk '{ print $1/4*2}'`
  printf "%s | %s\n" $name $numlines | sed 's/\./ | /g'
done > stats.txt
```


