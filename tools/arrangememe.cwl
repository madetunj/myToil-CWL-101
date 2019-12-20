#!/usr/bin/env cwl-runner
cwlVersion: v1.0
baseCommand: [ movefolder.sh ]
class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement
  expressionLib:
  - var var_output_name = function() {
      return inputs.meme.basename.split('memechip').slice(0)+'motifs';
   };

inputs:
  ame:
    type: Directory
    inputBinding: 
      position: 1
      valueFrom: |
        ${
            for (var i = 0; i < self.listing.length; i++) {
                if (self.listing[i].path.split('/').slice(-1) == 'ame.html') {
                  return self.listing[i].path.split('/').slice(0,-1).join('/');
                }
            }
            return null;
        }
    
  meme:
    type: Directory
    inputBinding: 
      position: 2
      valueFrom: |
        ${
            for (var i = 0; i < self.listing.length; i++) {
                if (self.listing[i].path.split('/').slice(-1) == 'meme.html') {
                  return self.listing[i].path.split('/').slice(0,-2).join('/');
                }
            }
            return null;
        }



  outputdir:
    type: string?
    inputBinding:
      position: 3
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
  finalDir:
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
