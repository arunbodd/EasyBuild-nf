#!/bin/bash
# Usage: Deploy easybuild installations, checking, post cleanup
# Example: bash run_easybuild.sh <process> <inputFile> <outDir>
# Example: bash run_easybuild.sh run sam_compiled/node1.txt sam_compiled/node1

# NOTES: 

### Process
##### check: checks installation status of all modules in given input
##### run: runs nextflow workflow
##### post: post installation chmod / cleanup

### Input
##### input file with the structure pathOfConfig,Software,Version

### outDir
##### path to outDir

# nohup bash run_easybuild.sh run conf/critical.csv /scicomp/groups-pure/Projects/easybuild/critical > /scicomp/groups-pure/Projects/easybuild/critical/critical_nohup.txt 2>&1 &
# nohup bash run_easybuild.sh run conf/community.csv /scicomp/groups-pure/Projects/easybuild/community > /scicomp/groups-pure/Projects/easybuild/community/community_nohup.txt 2>&1 &

# nohup bash run_easybuild.sh single conf/critical.csv /scicomp/groups-pure/Projects/easybuild/critical > /scicomp/groups-pure/Projects/easybuild/critical/critical_nohup.txt 2>&1 &
# nohup bash run_easybuild.sh single conf/community.csv /scicomp/groups-pure/Projects/easybuild/community > /scicomp/groups-pure/Projects/easybuild/community/community_nohup.txt 2>&1 &

# nohup bash run_easybuild.sh post conf/critical.csv /scicomp/groups-pure/Projects/easybuild/critical > /scicomp/groups-pure/Projects/easybuild/post_nohup.txt 2>&1 &


# source the setup
source /apps/x86_64/scbs/easybuild_setup.sh

# load module
module load Nextflow
module load EasyBuild

# set inputs
flag=$1
inputFile=$2
outDir=$3

# set config path
ebPath="/scicomp/groups-pure/Projects/easybuild/easybuild-easyconfigs/easybuild/easyconfigs"

##########################################################################
# check Flag
echo "**************************************************************"
if [[ $flag == "check" ]]; then
	echo "Process: Checking installations"
elif [[ $flag == "run" ]]; then
        echo "Process: Running Builds"
elif [[ $flag == "cleanup" ]]; then
	echo "Process: Post cleanup"
elif [[ $flag == "single" ]]; then
	echo "Process: Single processing"
else
    echo "Process invalid. Options are check run cleanup"
fi
echo "**************************************************************"

##########################################################################
# check input file
echo "**************************************************************"
if [[ ! -f $inputFile ]]; then 
        echo "Missing input file"
        exit
else
        echo "Input file is valid"
fi
echo "**************************************************************"

##########################################################################
# check outDir
if [[ $outDir == "" ]]; then
    echo "You must specify an outDir"
    exit
fi

#######################################################################
# Prepare installation
if [[ -f $outDir/install.txt ]]; then rm $outDir/install.txt; fi
if [[ ! -d $outDir ]]; then mkdir -p $outDir; fi

# gather modules to be installed
while read p; do

    # get variables
    config=`echo $p | cut -f1 -d","`
    software=`echo $p | cut -f2 -d","`
    version=`echo $p | cut -f3 -d","`       

    if module avail 2>&1 | grep -q "$software/$version*"; then
        echo "This module is already installed: $software/$version"
        echo "$config,$software,$version" >> completed.txt
    else
        echo "These modules will be installed: $software/$version"
        echo "$config,$software,$version" >> $outDir/tmp.txt
    fi

done < $inputFile

mv $outDir/tmp.txt $inputFile
#######################################################################
# Installation
# Installation
if [[ $flag == "single" ]]; then
    while read p; do
        if [[ $config == "config,software,version" ]]; then
            next
        else
            # get variables
            config=`echo $p | cut -f1 -d","`
            software=`echo $p | cut -f2 -d","`
            version=`echo $p | cut -f3 -d","`

            echo "**************************************************************"
            echo "**** Install: Install module $software/$version ****"

            # install the module
            eb $config --robot --detect-loaded-modules=unload --accept-eula-for=CUDA

            # Check if the module exist
            if module avail 2>&1 | grep -q "$software/$version*"; then
                    echo "**** SUCCESS: Module was installed: $software/$version ****"
                    echo "$config,$software,$version" >> completed.txt
            else
                    echo "**** FAIL: Module was not installed: $software/$version ****"
            fi
        fi
    done < $inputFile
elif [[ $flag == "run" ]]; then
        nextflow run main.nf \
        --input $inputFile \
        --outdir $outDir \
        -work-dir $outDir/work \
        -entry CDCGOV_EASYBUILD

elif [[ $flag == "post" ]]; then 
	# run post installation script
	sudo /apps/x86_64/scbs/post_install.sh
fi
