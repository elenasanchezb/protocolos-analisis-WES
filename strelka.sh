#!bin/bash

REF_DIR=
REF=

INPUT_DIR=
INPUT_BAM=

WORKFLOW_DIR=

#configuracion analisis
configureStrelkaGermlineWorkflow.py\
        --bam /${INPUT_DIR}/${INPUT_BAM}\
        --referenceFasta /${REF_DIR}/${REF}\
        --runDir ${WORKFLOW_DIR}\
        --exome

#ejecucion analisis
${WORKFLOW_DIR}/runWorkflow.py -m local -j 8
