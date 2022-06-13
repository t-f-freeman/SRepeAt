#!/usr/bin/env nextflow

/*
---------------------------------------------------------------------
    t-f-freeman/SRepeAt
---------------------------------------------------------------------
SRepeAt - A pipeline for analyzing repeat elements. Built on SRAlign.
https://github.com/t-f-freeman/SRepeAt
*/

nextflow.enable.dsl=2

/*
---------------------------------------------------------------------
    RUN MAIN WORKFLOW
---------------------------------------------------------------------
*/

include { SRepeAt } from "${projectDir}/workflows/SRepeAt.nf"

workflow {
    SRepeAt()
}
