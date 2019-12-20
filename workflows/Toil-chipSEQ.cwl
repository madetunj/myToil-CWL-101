#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  reference: Directory
  fastqfile: File
  chromsizes: File
  blacklistfile: File
  best_alignments: boolean?
  good_alignments: int?
  limit_alignments: int?
  processors: int?

outputs:
  fastq_metrics:
    outputSource: BasicMetrics/metrics_out
    type: File

  readqc_zip:
    outputSource: ReadQC/zipfile
    type: File

  readqc_html:
    outputSource: ReadQC/htmlfile
    type: File


steps:
  BasicMetrics:
    in:
      fastqfile: fastqfile
    out: [metrics_out]
    run: ../tools/basicfastqstats.cwl

  TagLen:
    in:
      datafile: BasicMetrics/metrics_out
    out: [tagLength]
    run: ../tools/taglength.cwl

  ReadQC:
    in:
      infile: fastqfile
    out: [htmlfile, zipfile]
    run: ../tools/fastqc.cwl

  Bowtie:
    requirements:
      ResourceRequirement:
        coresMin: 20
    run: ../tools/bowtie.cwl
    in:
      readLengthFile: TagLen/tagLength
      best_alignments: best_alignments
      good_alignments: good_alignments
      fastqfile: fastqfile
      limit_alignments: limit_alignments
      processors: processors
      reference: reference
    out: [samfile]
