process EASYBUILD_INSTALLATION {
    label 'process_low'
    tag "$software"
    
    input:
        tuple val(config), val(software), val(version)

    output:
        path(".log"),           emit: ebLogs
        path(".err"),           emit: ebErr

    script:

    """
    source /apps/x86_64/scbs/easybuild_setup.sh
    module load EasyBuild

    eb $config \
        --robot \
        --detect-loaded-modules=unload \
        --accept-eula-for=CUDA > ${software}-${version}.log 2> ${software}-${version}.err
    """
}
