A nextflow workflow to stage files from Gen3.

## Prerequisites

* You have authorization to download files listed in the manifest, from the
  specifed Gen3 endpoint.
* `GEN3_API_KEY` and `GEN3_KEY_ID` have been set as nextflow secrets.
 
## Example run 

```
nextflow run main.nf \
    --manifest `pwd`/manifest.json \
    --apiendpoint https://gen3.datacommons.io/
    --outdir s3://my-bucket/prefix
    --mode move
```

## Usage notes

* The default mode is `copy`, which retains files in the nextflow workdir as
  well as the target staging directory.
