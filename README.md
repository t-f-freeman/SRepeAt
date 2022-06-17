# SRepeAt
A pipeline for analyzing repeat elements. Built on SRAlign.

## Introduction

**SRepeAt** is a [Nextflow](https://www.nextflow.io/) pipeline for aligning short reads to a reference. 

## Pipeline overview

1. Trim reads
2. QC of reads
   1. Raw reads FastQC
   2. Trim reads FastQC
   3. Summary MultiQC
3. Align reads
    1. Align to reference genome/transcriptome
    2. Check contamination
4. Preprocess alignments
   1. Mark duplicates
   2. Compress sam to bam
   3. Index bam
5. QC of alignments
   1. samtools stats
   2. Samtools index stats
   3. Percent duplicates
   4. Percent aligned to contamination reference
   5. Summary MultiQC
6. Library complexity and reproducibility
   1. Preseq library complexity
   2. DeepTools correlation
   3. DeepTools PCA
7. Full pipeline MultiQC

## Quick start

1. [Install Nextflow](https://www.nextflow.io/docs/latest/getstarted.html)
2. [Install Docker](https://docs.docker.com/engine/install/)
3. Download **SRepeAt**:
    ```
    git clone https://github.com/t-f-freeman/SRepeAt
    ```
4. Run **SRepeAt** in test mode:
    ```
    nextflow run SRepeAt -profile test 
    ```
5. Run your analysis:
    ```
    nextflow run SRepeAt -profile docker --input <input.csv> --genome <valid genome key>
    ```

Detailed documentation can be found in [docs](docs/) and [usage](docs/usage.md)
