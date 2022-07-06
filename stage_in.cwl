#!/usr/bin/env cwltool

cwlVersion: v1.1
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: 'pymonger/downsample-dem:0.0.1'
baseCommand:
  - papermill
  - /home/jovyan/downsample-dem/stage_in.ipynb
  - output_nb.ipynb
requirements:
  ShellCommandRequirement: {}
  NetworkAccess:
    networkAccess: true

inputs:
  input_url:
    type: string
    inputBinding:
      position: 1
      shellQuote: false
      prefix: '--parameters'
      valueFrom: |
        input_url "$(self)"

outputs:
  output_nb_file:
    type: File
    outputBinding:
      glob: output_nb.ipynb
  inputs_dir:
    type: Directory
    outputBinding:
      glob: 'inputs'
#  stdout_file:
#    type: stdout
#  stderr_file:
#    type: stderr
#stdout: stage_in-stdout.txt
#stderr: stage_in-stderr.txt
