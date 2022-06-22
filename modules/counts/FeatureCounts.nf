/*
Author : Trevor F. Freeman <trevor.freeman@utexas.edu>
Date   : 2022-06-13
Purpose: Count number of reads in regions
*/

process FeatureCounts {
    tag "${outName}"

    container 'quay.io/biocontainers/subread:2.0.1--h7132678_2'

    label 'cpu_mid'
    label 'mem_mid'

    publishDir "${params.baseDirData}/counts", mode: 'copy', pattern: '*.txt*'

    input:
        tuple val(metadata), path(bam), path(bai), val(toolIDs)
        path annotationFile
        val featureType
        val attributeType

    output:
        tuple path('*txt'), val(toolIDs), emit: featCounts
        tuple path('*txt.summary'), val(toolIDs), emit: featCountsSummary

    script:
        // set suffix
        toolIDs += "srF-${annotationFile.toString() - ~/.gtf?/}"
        suffix = toolIDs ? "__${toolIDs.join('_')}" : ''

        // set arguments
        def options = task.ext.args ?: ''

        """
        featureCounts \
            -T ${task.cpus} \
            ${options} \
            -a ${annotationFile} -F GTF \
            -t ${featureType} -g ${attributeType} \
            -o ${metadata.sampleName}${suffix}.txt \
            ${bam}
        """
    
    stub:
        // set suffix
        toolIDs += "srF-${annotationFile.toString() - ~/.gtf?/}"
        suffix = toolIDs ? "__${toolIDs.join('_')}" : ''

        """
        touch ${metadata.sampleName}${suffix}.txt
        touch ${metadata.sampleName}${suffix}.txt.summary
        """
}
