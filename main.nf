process DL_FILES {

    container 'ubuntu:latest'
    
    secret 'GEN3_API_KEY'
    secret 'GEN3_KEY_ID'

    input:
    path manifest
    val apiendpoint

    def dldir = 'downloads'
    def profile = 'staging'
    def credentials = './credentials.json'

    output:
    path "${dldir}/*"

    publishDir "${params.outdir}", mode: "${params.mode}", saveAs: {
        fp -> fp.split('/').last()
    }

    script:
    """
    # FEATURE build a container with the client installed already
    apt-get update && apt-get install -y wget jq unzip
    wget https://github.com/uc-cdis/cdis-data-client/releases/latest/download/dataclient_linux.zip
    unzip dataclient_linux.zip
    chmod +x gen3-client
    mkdir $dldir
    echo '{"api_key":"'\$GEN3_API_KEY'","key_id":"'\$GEN3_KEY_ID'"}' > $credentials
    ./gen3-client configure \
        --apiendpoint $apiendpoint \
        --cred $credentials \
        --profile $profile 
    ./gen3-client download-multiple \
        --no-prompt \
        --download-path $dldir \
        --profile $profile \
        --manifest $manifest
    rm -f $credentials
    """

}

workflow {
    DL_FILES(params.manifest, params.apiendpoint) | flatten | view { fp ->
        "${params.outdir}/${fp.name}"
    }
}
