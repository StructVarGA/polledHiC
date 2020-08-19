#!/bin/env python3
import os
import glob

nfcore_dir = glob.glob('/work2/genphyse/dynagen/jmartin/polledHiC/workflows/nfcorehic_jm/*/')

tsv = []
for prot in nfcore_dir:
   path = prot + 'hic_results/matrix/raw/*'
   for mat in glob.glob(path):
     sample = '.'.join(mat.split('/')[-1].split('.')[:2])
     protocol = mat.split('/hic_results')[0].split('/')[-1]
     matrixprefix = '/'.join(mat.split('/')[:-1]) + '/' + sample
     line = sample + "\t" + protocol + "\t" + matrixprefix
     if line not in tsv:
        tsv.append(line)

tsv.sort()
with open('sampled_protocols.tsv', 'w') as fh:
   print('sample', 'protocol', 'matrixprefix', sep="\t", file = fh)
   for l in tsv:
      print(l, file = fh)

