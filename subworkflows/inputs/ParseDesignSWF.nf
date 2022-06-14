include { ParseDesign } from "${projectDir}/modules/inputs/ParseDesign.nf"
include { IndexBam    } from "${projectDir}/modules/align/IndexBam.nf"

workflow ParseDesignSWF {
    take:
        design

    main:
        ParseDesign(
            design
        )
            .csv
            .splitCsv(header:true, sep:',')
            .map { createDesignChannel(it) }
            .branch {
                reads: it[1].any { it =~ /(fastq|fq)/ }   // add channels with fastq files (either fastq or fq) to reads channel
                bams:  it[1].any { it =~ /\.bam$/ }       // add channels with bams to bams channel
            }
            .set { design }

        // Index bams
        IndexBam(
            design.bams
        )
            .set { bamBai }

    emit:
        reads  = design.reads
        bamBai = bamBai
}


// create a list of data from the csv
def createDesignChannel(LinkedHashMap row) {
    // reads
    if (row.fq1) {
        // store metadata in a Map
        def metadata = [:]
        metadata.libID      = row.lib_ID
        metadata.sampleName = row.sample_rep
        metadata.readType   = row.fq2 ? 'paired' : 'single'

        // store reads in a list
        def reads = []
        if (metadata.readType == 'single') {
            reads = [file(row.fq1)]
        } else {
            reads = [file(row.fq1), file(row.fq2)]
        }


        // create an empty list for tool IDs for suffixes
        toolIDs = []

        /*
        log.info "Workflow introspection for stub run: ${workflow.stubRun}"

        // check that reads files exist
        if (!workflow.stubRun) {        // ignore file checking for stub-run executions
            reads.each {
                if (!it.exists()) {
                    exit 1, "ERROR: ${it} does not exist!"
                }
            }
        }
        */

        return [metadata, reads, toolIDs]
    }
    
    // bams
    else if (row.bam) {
        // store metadata in a Map
        def metadata = [:]
        metadata.libID      = row.lib_ID
        metadata.sampleName = row.sample_rep

        // store bams
        bam = [file(row.bam)]

        // create an empty list for tool IDs for suffixes
        toolIDs = row.tool_IDs.split('_')

        /*

        // check that reads files exist
        if (!workflow.stubRun) {        // ignore file checking for stub-run executions
            bam.each {
                if (!it.exists()) {
                    exit 1, "ERROR: ${it} does not exist!"
                }
            }
        }
        */

        return [metadata, bam, toolIDs]
    }
}
