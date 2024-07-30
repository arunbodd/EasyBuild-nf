process CHECK_INSTALLATION {
    label 'process_low'
    
    input:
    tuple file(config), val(software), val(version)

    script:
    """
	source /usr/share/lmod/8.7.32/init/bash
	module use /modules/by-environ/generic-release/all

	if module avail 2>&1 | grep -q "$software/$version"; then
        	echo "Module is installed: $software/$version" > ${params.outdir}/logs/${software}_${version}_check.log
    	else
        	echo "Module is not installed: $software/$version" > ${params.outdir}/logs/${software}_${version}_check.log
    fi
    """
}
