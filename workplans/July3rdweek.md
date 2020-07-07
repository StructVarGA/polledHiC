
1. Influence of the provided restriction and ligation motifs on the HiC-Pro pipeline  
   - Try for example the Maison motifs on data produced using the Arima protocol
   - Check the impact of this misspecification on the MultiQC diagnostics

#### Summing matrices from different protocols

2. Install cooler : https://github.com/mirnylab/cooler
3. Use the appropriate cooler functionnality to merge two or more matrices
4. Merge two matrices using a homemade python script (see scripts/template_python.py for a template) *Optionnal*

#### Matrix normalization

5. Using hicCorrectMatrix from HiCExplorer normalize the resulting matrices (try both ICE and KRR)
6. Explore the difference between maps before and after normalization
7. Extract the main ideas from the paper suggested by Alain: https://www.future-science.com/doi/10.2144/btn-2019-0105
8. If everything is done, have a look at https://bioconductor.org/packages/devel/bioc/vignettes/HiCBricks/inst/doc/IntroductionToHiCBricks.html
