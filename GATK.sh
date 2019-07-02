#!bin/bash
  
REF_DIR=
REF=

INPUT_DIR=
INPUT_BAM=

OUTPUT_DIR=
OUTPUT_BQSR_BAM=
OUTPUT_RAW_VCF=
OUTPUT_RAW_SNPS_VCF=
OUTPUT_RAW_INDELS_VCF=
OUTPUT_FILTERED_SNPS_VCF=
OUTPUT_FILTERED_INDELS_VCF=
OUTPUT_FILTERED_VCF=
OUTPUT_FILTERED_SORTED_VCF=

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
  -O /${OUTPUT_DIR}/${OUTPUT_BQSR_BAM}\
  -R /${REF_DIR}/${REF}
                                
gatk HaplotypeCaller\
  -R /${REF_DIR}/${REF}\
  -I /${OUTPUT_DIR}/${OUTPUT_BQSR_BAM}\
  -O /${OUTPUT_DIR}/${OUTPUT_RAW_VCF}
  
  
#por defecto el filtrado se aplica en modo SNP

gatk SelectVariants\
  -R /${REF_DIR}/${REF}\
  -V /${OUTPUT_DIR}/${OUTPUT_RAW_VCF}\
  -O //${OUTPUT_DIR}/${OUTPUT_RAW_SNPS_VCF}\
  --select-type SNP
  
gatk VariantFiltration\
  -R /${REF_DIR}/${REF}\
  -V /${OUTPUT_DIR}/${OUTPUT_RAW_SNPS_VCF}
  -o /${OUTPUT_DIR}/${OUTPUT_FILTERED_SNPS_VCF}
  --filter-expresion "QD<2.0||FS>60.0||MQ<40.0||MQRankSum<-12.5||ReadPosRankSum<-8.0"\
  --filter-name "filtro.snps"
  

gatk SelectVariants\
  -R /${REF_DIR}/${REF}\
  -V /${OUTPUT_DIR}/${OUTPUT_RAW_VCF}\
  -O //${OUTPUT_DIR}/${OUTPUT_RAW_INDELS_VCF}\
  --select-type INDEL
  
gatk VariantFiltration\
  -R /${REF_DIR}/${REF}\
  -V /${OUTPUT_DIR}/${OUTPUT_RAW_INDELS_VCF}
  -o /${OUTPUT_DIR}/${OUTPUT_FILTERED_INDELS_VCF}
  --filter-expresion "QD<2.0||FS>200.0||ReadPosRankSum>-20.0"\
  --filter-name "filtro.indels"
  
#union de archivo con indels y snps filtrados

bgzip /${OUTPUT_DIR}/${OUTPUT_FILTERED_SNPS_VCF}

bgzip/${OUTPUT_DIR}/${OUTPUT_FILTERED_INDELS_VCF}

tabix /${OUTPUT_DIR}/${OUTPUT_FILTERED_SNPS_VCF}.gz

tabix /${OUTPUT_DIR}/${OUTPUT_FILTERED_INDELS_VCF}

bctools concat -O z-o /${OUTPUT_DIR}/${OUTPUT_FILTERED_VCF}.gz -a /${OUTPUT_DIR}/${OUTPUT_FILTERED_SNPS_VCF}.gz /${OUTPUT_DIR}/${OUTPUT_FILTERED_INDELS_VCF}.gz

bcftools sort -O -o /${OUTPUT_DIR}/${OUTPUT_FILTERED_SORTED_VCF}.gz /${OUTPUT_DIR}/${OUTPUT_FILTERED_VCF}.gz

tabix /${OUTPUT_DIR}/${OUTPUT_FILTERED_SORTED_VCF}.gz
        
