#!bin/bash
  
REF_DIR=
REF=

INPUT_DIR=
INPUT_BAM=

OUTPUT_DIR=
OUTPUT_BAM=

#BaseRecalibration
#GATK necesita archivos con sitios conocidos, que dependerán del genoma de referencia. Para hg19, se necesitan tres archivos, para hg38 dos, ya que uno de ellos combina dos de los que se usan para hg19.
#Hay diferencias introducendo esto en el preprocesado para las otras herramientas.

KNOWN_SITES_DIR=
KNOWN_SITES_DBSNP=
KNOWN_SITES_MILLS_AND_1000G=

gatk BaseRecalibrator\
        -I /${INPUT_DIR}/${INPUT_BAM}\
        --kwown-sites /${KNOWN_SITES_DIR}/${KNOWN_SITES_DBSNP}\
        --kwnon_sites /${KNOWN_SITES_DIR}/${KNOWN_SITES_MILLS_AND_1000G}\
        -O /${OUTPUT_DIR}/BaseRecal.table\
        -R /${RED_DIR}/${REF}

gatk ApplyBQSR\
        -bqsr /${OUTPUT_DIR}/BaseRecal.table\
        -I /${INPUT_DIR}/${INPUT_BAM}\
        -O /${OUTPUT_DIR}/${OUTPUT_BAM}\
        -R /${REF_DIR}/${REF}
                                
