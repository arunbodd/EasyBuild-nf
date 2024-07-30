#!/bin/bash

# OBJECTIVE: Learn how to install modules with EasyBuild
# DATE: 7/10/2024
# AUTHOR: S.Chill

##############################################################################
### Manual Installations
##############################################################################
# source the setup
source /apps/x86_64/scbs/easybuild_setup.sh

# load easybuild
module load EasyBuild

# Install your module
eb \
/scicomp/groups-pure/Projects/easybuild/easybuild-easyconfigs/easybuild/easyconfigs/<letter>/<module>/<module>.eb \
--robot \
--detect-loaded-modules=unload \
--accept-eula-for=CUDA

# run post installation script
sudo /apps/x86_64/scbs/post_install.sh

# verify the module is installed and works
module availe <softwarename>/<version>
<softwarename> --help
<softwarename> --version

##############################################################################
### Single Run Installations
##############################################################################
# NOTES: 
### Process
##### check: checks installation status of all modules in given input
##### single: runs single installations, consecutively
##### nf: runs nextflow workflow
##### post: post installation chmod / cleanup

### Input
##### input file with the structure pathOfConfig,Software,Version

### outDir
##### path to outDir

# Utilize Run Script
# Example: bash run_easybuild.sh <process> <inputFile> <outDir>
bash run_easybuild.sh run sam_compiled/node1.txt sam_compiled/node1

##############################################################################
### Single Run Installations, no interaction
##############################################################################
# NOTES: 
### Process
##### check: checks installation status of all modules in given input
##### single: runs single installations, consecutively
##### nf: runs nextflow workflow
##### post: post installation chmod / cleanup

### Input
##### input file with the structure pathOfConfig,Software,Version

### outDir
##### path to outDir

# Utilize Run Script with nohup
# Example: nohup bash run_easybuild.sh <process> <inputFile> <outDir> > <nohupFile> 2>&1 &
nohup bash run_easybuild.sh run conf/critical.csv /scicomp/groups-pure/Projects/easybuild/critical > /scicomp/groups-pure/Projects/easybuild/critical/critical_nohup.txt 2>&1 &

##############################################################################
### NF Installations, no interaction
##############################################################################
# NOTES: 
### Process
##### check: checks installation status of all modules in given input
##### single: runs single installations, consecutively
##### nf: runs nextflow workflow
##### post: post installation chmod / cleanup

### Input
##### input file with the structure pathOfConfig,Software,Version

### outDir
##### path to outDir

# Utilize Run Script with nohup
# Example: nohup bash run_easybuild.sh <process> <inputFile> <outDir> > <nohupFile> 2>&1 &
nohup bash run_easybuild.sh nf conf/critical.csv /scicomp/groups-pure/Projects/easybuild/critical > /scicomp/groups-pure/Projects/easybuild/critical/critical_nohup.txt 2>&1 &

##############################################################################
### Check
##############################################################################
# NOTES: 
### Process
##### check: checks installation status of all modules in given input
##### single: runs single installations, consecutively
##### nf: runs nextflow workflow
##### post: post installation chmod / cleanup

### Input
##### input file with the structure pathOfConfig,Software,Version

### outDir
##### path to outDir

# Utilize Run Script
# Example: bash run_easybuild.sh <process> <inputFile> <outDir>
bash run_easybuild.sh check

##############################################################################
### Post admin modifications
##############################################################################
# NOTES: 
### Process
##### check: checks installation status of all modules in given input
##### single: runs single installations, consecutively
##### nf: runs nextflow workflow
##### post: post installation chmod / cleanup

### Input
##### input file with the structure pathOfConfig,Software,Version

### outDir
##### path to outDir

# Utilize Run Script with nohup
# Example: bash run_easybuild.sh <process> <inputFile> <outDir>
bash run_easybuild.sh post