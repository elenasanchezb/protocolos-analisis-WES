#!bin/bash

REF_DIR=
REF=

INPUT_DIR=
INPUT_BAM=

OUTPUT_DIR=
OUTPUT_RAW_VCF=
OUTPUT_VCF=

bcftools mpileup\
  -O u\
  -f /${REF_DIR}/${REF}\
  /${INPUT_DIR}/${INPUT_BAM}\
  | bcftools call\
  -v\
  -m\
  -O z\
  -o /${OUTPUT_DIR}/${OUTPUT_RAW_VCF}.gz
 
tabix /${OUTPUT_DIR}/${OUTPUT_RAW_VCF}.gz

bcftools filter\
  -O z\
  -o /${OUTPUT_DIR}/${OUTPUT_VCF}.gz\
  -s LOWQUAL\
  -i '%QUAL>10'\
  /${OUTPUT_DIR}/${OUTPUT_RAW_VCF}.gz
 
tabix /${OUTPUT_DIR}/${OUTPUT_VCF}.gz
