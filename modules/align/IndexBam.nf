/*
Author : Trevor F. Freeman <trvrfreeman@gmail.com>
Date   : 2022-02-27
Purpose: Nextflow module
*/

process IndexBam {
    tag "${metadata.sampleName}"

    label 'cpu_mid'
    label 'mem_mid'

    container 'quay.io/biocontainers/samtools:1.15--h1170115_1'

    publishDir "${params.baseDirData}/align", mode: 'copy', pattern: '*.bai'

    input:
        tuple val(metadata), path(bam), val(toolIDs)

    output:
        tuple val(metadata), path(bam), path('*.bai'), val(toolIDs), emit: bamBai

    script:
        """
        samtools index \
            -@ ${task.cpus} \
            -b ${bam}
        """
    
    stub:
        """
        touch ${bam}.bai
        """
}
