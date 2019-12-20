#!/usr/bin/env cwl-runner
cwlVersion: v1.0
baseCommand: ame
class: CommandLineTool

label: AME - Analysis of Motif Enrichment
doc: |
  ame <convert fasta> <motif-databases>

requirements:
- class: InlineJavascriptRequirement
  expressionLib:
  - var var_output_name = function() {
      return inputs.convertfasta.nameroot+'-ame_out';
   };

inputs:
  convertfasta:
    type: File
    inputBinding:
      position: 999
  
  motifdatabases:
    type: 
      type: array
      items: string
    inputBinding:
      position: 1000

  outputdir:
    type: string?
    inputBinding:
      position: 1
      prefix: -oc
      valueFrom: |
        ${
            if (self == ""){
              return var_output_name();
            } else {
              return self;
            }
        }
    default: ""
      
      

outputs:
  outDir:
    type: Directory
    outputBinding:
      glob: |
        ${
          if (inputs.outputdir == "") {
            return var_output_name();
          } else {
            return inputs.outputdir;
          }
        }
