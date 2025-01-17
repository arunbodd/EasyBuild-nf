process CHECK_INSTALLATION {
    label 'process_low'
    
    input:
    tuple val(config), val(software), val(version)

    output:

    file("${software}-${version}-check.log") , emit: statusLog
    
    script:
    """
	source /usr/share/lmod/8.7.32/init/bash
	module use /modules/by-environ/generic-release/all

	if module avail 2>&1 | grep -q "$software/$version"; then
        	echo "Module is installed: $software/$version" > ${software}-${version}-check.log
    	else
        	echo "Module is not installed: $software/$version" > ${software}-${version}-check.log
    	fi
    """
}
