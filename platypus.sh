#!bin/bash

REF_DIR=
REF=

INPUT_DIR=
INPUT_BAM=

OUTPUT_DIR=
OUTPUT_VCF=

THREADS=
#Platypus puede realizar la eliminación de duplicados, pero el resultado es el mismo que con GATK MarkDuplicates

platypus callVariants\
  --bamFiles /${INPUT_DIR}/${INPUT_BAM}\
  --refFile /${REF_DIR}/${REF}\
  -o /${OUTPUT_DIR}/{OUTPUT_VCF}\
  --nCPU ${THREADS]\
  --filterDuplicates=1

bgzip ${OUTPUT_DIR}/${OUTPUT_VCF}
tabix ${OUTPUT_DIR}/${OUTPUT_VCF}.gz
