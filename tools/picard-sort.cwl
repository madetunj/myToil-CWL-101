#!/usr/bin/env cwl-runner
cwlVersion: v1.0
baseCommand: [java, -Xmx4g, -jar, /hpcf/authorized_apps/rhel7_apps/picard/install/2.21.2/picard.jar, SortSam]
class: CommandLineTool
label: sort bam file using picard tools

requirements:
- class: ShellCommandRequirement
- class: InlineJavascriptRequirement

  expressionLib:
  - var var_output_name = function() {
      if (inputs.infile != null) {
         return inputs.infile.nameroot.split('.bam')[0]+'.sorted.bam';
      }
   };

inputs:
  infile:
    type: File
    inputBinding:
      position: 1
      prefix: 'I='
      separate: false

  sort-order:
    type: string?
    default: "coordinate"
    inputBinding:
      position: 3
      prefix: "SORT_ORDER="
      separate: false

  outfile:
    type: string?
    inputBinding:
      position: 2
      prefix: 'O='
      separate: false
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
  outfile:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.outfile == "") {
            return var_output_name();
          } else {
            return inputs.outfile;
          } 
        }
