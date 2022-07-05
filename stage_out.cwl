#!/usr/bin/env cwltool

cwlVersion: v1.1
class: CommandLineTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#
hints:
  "cwltool:Secrets":
    secrets:
      - aws_access_key_id
      - aws_secret_access_key
  DockerRequirement:
    dockerPull: pymonger/aws-cli
requirements:
  NetworkAccess:
    networkAccess: true
  InitialWorkDirRequirement:
    listing:
      - entryname: .aws/credentials
        entry: |
          [default]
          output = json
          region = us-west-2
          aws_access_key_id = $(inputs.aws_access_key_id)
          aws_secret_access_key = $(inputs.aws_secret_access_key)

# the following baseCommand and arguments work on docker but not singularity
#baseCommand: [aws]
#arguments: [
#  "s3",
#  "cp",
#  "--recursive",
#]

# the following baseCommand and arguments work on both docker and singularity
baseCommand: [sh]
arguments:
- -c
- if [ ! -d $HOME/.aws ]; then cp -rp .aws $HOME/; fi &&
  aws s3 cp --recursive $(inputs.dataset_dir.path) $(inputs.base_dataset_url)/$(inputs.dataset_dir.basename)

inputs:
  aws_access_key_id: string
  aws_secret_access_key: string
  dataset_dir:
    type: Directory
    # uncomment these if using baseCommand: [aws]
    #inputBinding:
    #  position: 1
  base_dataset_url:
    type: string
    # uncomment these if using baseCommand: [aws]
    #inputBinding:
    #  position: 2
outputs: []
#outputs:
#  stdout_file:
#    type: stdout
#  stderr_file:
#    type: stderr
#stdout: stage_out-stdout.txt
#stderr: stage_out-stderr.txt
