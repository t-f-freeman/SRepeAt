/*
Author : Trevor F. Freeman <trevor.freeman@utexas.edu>
Date   : 2022-06-19
Purpose: Count number of reads in regions
*/

include { FeatureCounts } from "${projectDir}/modules/counts/FeatureCounts.nf"

workflow FeatureCountsSWF {
    take:
        bamIndexed
        annotationFile
        featureType
        attributeType

    main:
        FeatureCounts(
            bamIndexed,
            annotationFile,
            featureType,
            attributeType,
        )

    emit:
        countsFeatureCounts  = FeatureCounts.out.featCounts
        summaryFeatureCounts = FeatureCounts.out.featCountsSummary
}
