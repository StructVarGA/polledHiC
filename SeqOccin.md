
#### Available HiC data in SeqOccin

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


