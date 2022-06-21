/*
Author : Trevor F. Freeman <trevor.freeman@utexas.edu>
Date   : 2022-06-20
Purpose: Sort bam entries by name
*/

process SamtoolsSortName {
    tag "${metadata.sampleName}"

    container 'quay.io/biocontainers/samtools:1.15--h1170115_1'

    publishDir "${params.baseDirData}/align", mode: 'copy', pattern: '*.bam'

    input:
        tuple val(metadata), path(bam), path(bai), val(toolIDs)

    output:
        tuple val(metadata), file('*.bam'), val(toolIDs), emit: bamSortedName

    script:
        // update toolID and set suffix
        toolIDs += 'sSR-name'
        suffix = toolIDs ? "__${toolIDs.join('_')}" : ''

        """
        samtools sort \
            -n \
            -@ ${task.cpus} \
            -o ${metadata.sampleName}${suffix}.bam \
            ${bam}
        """
    
    stub:
        // update toolID and set suffix
        toolIDs += 'sSR-name'
        suffix = toolIDs ? "__${toolIDs.join('_')}" : ''

        """
        touch ${metadata.sampleName}${suffix}.bam
        """
}
