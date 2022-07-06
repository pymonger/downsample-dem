#!/usr/bin/env cwltool

cwlVersion: v1.1
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: 'pymonger/downsample-dem:0.0.1'
baseCommand:
  - papermill
  - /home/jovyan/downsample-dem/downsample_dem.ipynb
  - output_nb.ipynb
requirements:
  ShellCommandRequirement: {}
  InitialWorkDirRequirement:
    listing: 
      - $(inputs.inputs_dir)

inputs:
  inputs_dir:
    type: Directory
    inputBinding:
      position: 1
      shellQuote: false
      prefix: '--parameters'
      valueFrom: |
        inputs_dir "$(self.basename)"
  min_stress_time:
    type: int
    inputBinding:
      position: 2
      shellQuote: false
      prefix: '--parameters'
      valueFrom: |
        min_stress_time "$(self)"
  max_stress_time:
    type: int
    inputBinding:
      position: 3
      shellQuote: false
      prefix: '--parameters'
      valueFrom: |
        max_stress_time "$(self)"

outputs:
  output_nb_file:
    type: File
    outputBinding:
      glob: output_nb.ipynb
  outputs_dir:
    type: Directory
    outputBinding:
      glob: 'outputs'
#  stdout_file:
#    type: stdout
#  stderr_file:
#    type: stderr
#stdout: downsample_dem-stdout.txt
#stderr: downsample_dem-stderr.txt
