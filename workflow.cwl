#!/usr/bin/env cwltool

cwlVersion: v1.1
class: Workflow
$namespaces:
  cwltool: 'http://commonwl.org/cwltool#'
hints:
  'cwltool:Secrets':
    secrets:
      - workflow_aws_access_key_id
      - workflow_aws_secret_access_key

inputs:
  workflow_input_url: string
  workflow_min_stress_time: int
  workflow_max_stress_time: int
  workflow_aws_access_key_id: string
  workflow_aws_secret_access_key: string
  workflow_base_dataset_url: string

outputs:
  final_outputs_dir:
    type: Directory
    outputSource: downsample_dem/outputs_dir
#  stdout-downsample_dem:
#    type: File
#    outputSource: downsample_dem/stdout_file
#  stderr-downsample_dem:
#    type: File
#    outputSource: downsample_dem/stderr_file
#  stdout-stage_out:
#    type: File
#    outputSource: stage_out/stdout_file
#  stderr-stage_out:
#    type: File
#    outputSource: stage_out/stderr_file

steps:

  stage_in:
    run: stage_in.cwl
    in:
      input_url: workflow_input_url
    out:
      - output_nb_file
      - image_file
#      - stdout_file
#      - stderr_file

  downsample_dem:
    run: downsample_dem.cwl
    in:
      input_file: stage_in/image_file
      min_stress_time: workflow_min_stress_time
      max_stress_time: workflow_max_stress_time
    out:
      - output_nb_file
      - outputs_dir
#      - stdout_file
#      - stderr_file

  stage_out:
    run: stage_out.cwl
    in:
      aws_access_key_id: workflow_aws_access_key_id
      aws_secret_access_key: workflow_aws_secret_access_key
      outputs_dir: downsample_dem/outputs_dir
      base_dataset_url: workflow_base_dataset_url
    out: []
#    out:
#      - stdout_file
#      - stderr_file
