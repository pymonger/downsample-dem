# downsample-dem
Example CWL workflow calling a papermilled notebook.

## Run Jupyter Lab to view, edit and/or execute the algorithm notebook:
1. Start up Jupyter Lab in a docker container:
   ```
   git clone https://github.com/pymonger/downsample-dem.git
   cd downsample-dem
   docker run -p 8888:8888 -v ${PWD}:/home/jovyan/downsample-dem \
     pymonger/downsample-dem:latest jupyter lab --ip 0.0.0.0
   ```
1. Open the `downsample_dem.ipynb` notebook and run it.

## Building the container image
```
pip install jupyter-repo2docker
git clone https://github.com/pymonger/downsample-dem.git
cd downsample-dem
repo2docker --user-id 1000 --user-name jovyan \
  --target-repo-dir /home/jovyan/downsample-dem \
  --no-run --image-name pymonger/downsample-dem:latest .
```

## Running cwltool

### Prerequisites

1. Clone repo:
   ```
   cd /tmp
   git clone https://github.com/pymonger/downsample-dem.git
   cd downsample-dem
   ```
1. Create virtualenv:
   ```
   virtualenv env
   source env/bin/activate
   ```
1. Install `cwltool`:
   ```
   pip install cwltool
   ```

### Run 3-step workflow (stage-in, downsample-dem, stage-out) example
1. Copy the `workflow-inputs.yml.tmpl` file to `workflow-inputs.yml`:
   ```
   cp workflow-inputs.yml.tmpl workflow-inputs.yml
   ```

   then edit `workflow-inputs.yml`:
   ```
   vi workflow-inputs.yml
   ```

   and insert the values for:
   1. `workflow_aws_access_key_id`
   1. `workflow_aws_secret_access_key`

   These values can be copied from your valid `$HOME/.aws/credentials` file.
1. Change the value of `workflow_base_dataset_url` to point to the S3 location 
   where the dataset will be staged out to. Make sure the AWS creds you populated
   in the previous step allows for writing to this bucket location.
1. Run cwltool (to run singularity instead of docker, add `--singularity` option):
   ```
   cwltool --no-match-user --no-read-only workflow.cwl workflow-inputs.yml
   ```
1. Verify that the `Copernicus_DSM_COG_10_N21_00_W159_00_DEM_downsampled` dataset directory exists locally:
   ```
   ls -ltr Copernicus_DSM_COG_10_N21_00_W159_00_DEM_downsampled/
   ```

   Output should look similar to this:
   ```
   total 136
   -rw-r--r--  1 pymonger  wheel  20577 Mar 16 07:28 Copernicus_DSM_COG_10_N21_00_W159_00_DEM_downsampled.tif
   -rw-r--r--  1 pymonger  wheel  37187 Mar 16 07:28 Copernicus_DSM_COG_10_N21_00_W159_00_DEM_downsampled.browse.png
   -rw-r--r--  1 pymonger  wheel   3229 Mar 16 07:28 Copernicus_DSM_COG_10_N21_00_W159_00_DEM_downsampled.met.json
   ```

   and was staged to the S3 bucket location:
   ```
   aws s3 ls $(grep workflow_base_dataset_url workflow-inputs.yml | awk '{print $2}')/$(ls -d *_downsampled)/
   ```

   Output should look similar to this:
   ```
   2022-03-16 07:28:45      20577 Copernicus_DSM_COG_10_N21_00_W159_00_DEM_downsampled.tif
   2022-03-16 07:28:45      37187 Copernicus_DSM_COG_10_N21_00_W159_00_DEM_downsampled.browse.png
   2022-03-16 07:28:45       3229 Copernicus_DSM_COG_10_N21_00_W159_00_DEM_downsampled.met.json
   ```
