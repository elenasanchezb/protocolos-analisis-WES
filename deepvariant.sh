#!bin/bash
  
BIN_VERSION="0.8.0"

REF_DIR=
REF=

INPUT_DIR=
INPUT_BAM=

OUTPUT_DIR=
OUTPUT_VCF=
mkdir -p "${OUTPUT_DIR}"

N_SHARDS="8"

sudo docker run\
        -v "${INPUT_DIR}":"/indir"\
        -v "${OUTPUT_DIR}:/outdir"\
        -v "${REF_DIR}":"/refdir"\
        gcr.io/deepvariant-docker/deepvariant:"${BIN_VERSION}"\
        /opt/deepvariant/bin/run_deepvariant\
        --model_type=WES\
        --ref=/refdir/${REF}\
        --reads=/indir/${INPUT_BAM}\
        --output_vcf=/outdir/${OUTPUT_VCF}\
        --num_shards=${N_SHARDS}
        
bgzip ${OUTPUT_DIR}/${OUTPUT_VCF}
tabix ${OUTPUT_DIR}/${OUTPUT_VCF}.gz
