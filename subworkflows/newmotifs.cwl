#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs: 
  reference: Directory
  bedfile: File
  motifdatabases: string[]

outputs:
  memechipdir:
    type: Directory
    outputSource: MEMECHIP/outDir

  amedir:
    type: Directory
    outputSource: AME/outDir
 
  bedfasta:
    type: File
    outputSource: BEDfasta/outfile
    
  arrange:
    type: Directory
    outputSource: ARRANGEMEME/finalDir

steps:  
  MEMECHIP:
    run: ../tools/meme-chip.cwl
    in:
      convertfasta: BEDfasta/outfile
    out: [outDir]

  AME:
    run: ../tools/ame.cwl
    in:
      convertfasta: BEDfasta/outfile
      motifdatabases: motifdatabases
    out: [outDir]

  BEDfasta:
    in:
      reference: reference
      bedfile: bedfile
    out: [outfile]
    run: ../tools/bedfasta.cwl

  ARRANGEMEME:
    in:
      meme: MEMECHIP/outDir
      ame: AME/outDir
    out: [finalDir]
    run: ../tools/arrangememe.cwl


doc: |
  Workflow calls MOTIFS both enriched and discovered using the MEME-suite (AME & MEME-chip).
