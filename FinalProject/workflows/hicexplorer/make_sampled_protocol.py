#!/bin/env python3

"""
This script will take nfcore-hic nextflow's results to write
a sampled_protocols.tsv file that contains :

sample      protocol      matrixprefix

This file is necessary to run the Snakefile. You could run it directly doing :

python make_sampled_protocol.py

This script is called by nfcore-hic.sh so, it's a possibility to control .tsv but not a necessity to run before.
"""

import os
import glob

nfcore_dir = # path/to/nfcore_directory/*/ <- the '/*/' at the end allow to only return directory with glob.
nfcore_res = glob.glob(nfcore_dir)

tsv = []
for res in nfcore_res:
   path = res + 'hic_results/matrix/raw/*'
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

