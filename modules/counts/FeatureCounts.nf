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
        path bams
        val toolIDsBams
        path annotationFile
        val featureType
        val attributeType
        val outName

    output:
        tuple path('*txt'), val(toolIDsBams), emit: featCounts
        tuple path('*txt.summary'), val(toolIDsBams), emit: featCountsSummary

    script:
        // set suffix
        toolIDsBams += "srF-${annotationFile.toString() - ~/.gtf?/}"
        suffix = toolIDsBams ? "__${toolIDsBams.join('_')}" : ''

        // set arguments
        def options = task.ext.args ?: ''

        """
        featureCounts \
            -T ${task.cpus} \
            ${options} \
            -a ${annotationFile} -F GTF \
            -t ${featureType} -g ${attributeType} \
            -o ${outName}${suffix}.txt \
            ${bams}
        """
    
    stub:
        // set suffix
        toolIDsBams += "srF"
        suffix = toolIDsBams ? "__${toolIDsBams.join('_')}" : ''

        """
        touch ${outName}${suffix}.txt
        touch ${outName}${suffix}.txt.summary
        """
}
