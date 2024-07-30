process EASYBUILD_INSTALLATION {
    label 'process_medium'
    
    input:
    tuple val(config), val(software), val(version)


    script:

    """
    source /apps/x86_64/scbs/easybuild_setup.sh
    module load EasyBuild

    config_path="${params.ebpath}/${config}"

    eb \$config_path --robot --allow-loaded-modules=Java/11.0.20,Nextflow/24.04.2
    """
}
