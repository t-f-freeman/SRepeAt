/*
Author : Trevor F. Freeman <trevor.freeman@utexas.edu>
Date   : 2022-06-20
Purpose: Assign transposons to single loci
*/

process TelescopeBulkAssign {
    tag "${metadata.sampleName}"

    container 'quay.io/biocontainers/telescope:1.0.3--py36h14c3975_0'

    publishDir "${params.baseDirData}/counts/telescope", mode: 'copy', pattern: '*'

    input:
        tuple val(metadata), path(bam), val(toolIDs)
        path annotations

    script:
        // update toolID and set suffix
        toolIDs += 'teA'
        suffix = toolIDs ? "__${toolIDs.join('_')}" : ''

        """
        telescope assign \
            --attribute transcript_id \
            ${bam} ${annotations}
        """
    
    stub:
        """
        """
}
