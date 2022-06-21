/*
Author : Trevor F. Freeman <trevor.freeman@utexas.edu>
Date   : 2022-06-20
Purpose: Run Telescope: Assign reads to a single transposable element locus and count reads within repeats
*/

include { SamtoolsSortName    } from "${projectDir}/modules/align/SamtoolsSortName.nf"
include { TelescopeBulkAssign } from "${projectDir}/modules/counts/TelescopeBulkAssign.nf"

workflow TelescopeSWF {
    take:
        bamIndexed
        repeatsGTF

    main:
        // sort bam by name
        SamtoolsSortName(
            bamIndexed
        )

        // run Telescope on sorted bam
        TelescopeBulkAssign(
            SamtoolsSortName.out.bamSortedName,
            repeatsGTF
        )

    emit:
        bamSortedName = SamtoolsSortName.out.bamSortedName
}
