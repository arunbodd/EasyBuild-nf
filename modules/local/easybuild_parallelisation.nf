process EASYBUILD_INSTALLATION {
    label 'process_high'
    input:
    tuple val(config), val(software), val(version)

    output:
    file("${params.outdir}/logs/${software}-${version}.log"), emit: installedLogs
    file("${params.outdir}/logs/${software}-${version}.err),  emit: errLogs

    script:

    """
    source /apps/x86_64/scbs/easybuild_setup.sh
    module load EasyBuild

    eb ${params.ebPath}/$config --robot --detect-loaded-modules=unload --accept-eula-for=CUDA > ${params.outdir}/logs/${software}-${version}.log 2> ${params.outdir}/logs/${software}-${version}.err
    """
}
