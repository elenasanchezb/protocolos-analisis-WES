#!bin/bash

REF_DIR=
REF_2bit=
REF=

SAMPLE_DIR=
SAMPLE_FASTQ_1=
SAMPLE_FASTQ_2=

OUTPUT_DIR=
OUTPUT_SAM=
OUTPUT_BAM=
OUTPUT_FIXMATE_BAM=
OUTPUT_SORTED_BAM=
OUTPUT_MARDKEDDUP_BAM=

RG=

THREADS=


twoBitToFa ${REF_DIR}/${REF_2bit} ${REF}

bwa index -a bwts /${REF_DIR}/${REF}

samtools faidx /${REF_DIR}/${REF}

gatk CreateSequenceDictionary /${REF_DIR}/${REF}

bwa mem\
  -t ${THREADS}\
  -R "@RG\t${RG}"\
  -o /${OUTPUT_DIR}/${OUTPUT_SAM}
  /${REF_DIR}/${REF}\
  /${INPUT_DIR}/${INPUT_FASTQ_1} /${INPUT_DIR}/${INPUT_FASTQ_1}

samtools view\
  -b -o /${OUTPUT_DIR}/${OUTPUT_BAM}\
  /${OUTPUT_DIR}/${OUTPUT_SAM}

samtools fixmate\
  /${OUTPUT_DIR}/${OUTPUT_BAM}\
  /${OUTPUT_DIR}/${OUTPUT_FIXMATE_BAM}\

gatk SortSam\
  -I /${OUTPUT_DIR}/${OUTPUT_FIXMATE_BAM}\
  -O /${OUTPUT_DIR}/${OUTPUT_SORTED_BAM}\
  -SO coordinate
  
gatk MarkDuplicates\
  -I /${OUTPUT_DIR}/${OUTPUT_SORTED_BAM}\
  -O /${OUTPUT_DIR}/${OUTPUT_MARDKEDDUP_BAM}\
  -M markduplicates_metrics.txt
