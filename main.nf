process DL_FILES {

    container 'ubuntu:latest'
    
    secret 'GEN3_API_KEY'
    secret 'GEN3_KEY_ID'

    input:
    path manifest
    val apiendpoint
    
    script:
    """
    credstore='./credentials.json'
    profile='staging'
    # FEATURE build a container with the client installed already
    apt-get update && apt-get install -y wget jq unzip
    wget https://github.com/uc-cdis/cdis-data-client/releases/latest/download/dataclient_linux.zip
    unzip dataclient_linux.zip
    chmod +x gen3-client
    mkdir downloads
    echo '{"api_key":"'\$GEN3_API_KEY'","key_id":"'\$GEN3_KEY_ID'"}' > \$credstore
    ./gen3-client configure --apiendpoint $apiendpoint --cred \$credstore --profile \$profile
    ./gen3-client download-multiple --no-prompt --download-path downloads --profile \$profile --manifest $manifest
    rm -f \$credstore
    """
    output:
    path 'downloads/*', emit: downloads
}

workflow {
    DL_FILES(params.manifest, params.apiendpoint)
    DL_FILES.out.downloads.view()
    emit:
    staged = DL_FILES.out.downloads
}
