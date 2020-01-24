#!/usr/bin/env bash
#------
###SYNTAX to run
#bsub -P watcher -q compbio -J rose-toil -o rose-toil_out -e rose-toil_err -N ./rose.sh
####

#------
###FILES
#------
location="/rgs01/project_space/abrahgrp/Software_Dev_Sandbox/common/101madetunji/ToilGettingThere"
parameters="$location/temp-parameters.yml" #$1" #inputparameters.yml"
script="$location/workflows/rose.cwl" #ToilChipSeq-1st-mapping.cwl"

OLD_UUID=$1
NEW_UUID=${NEW_UUID:=${OLD_UUID%%.yml}} #reuse old file
NEW_UUID=${NEW_UUID:=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"_"`date +%s`} #temporary file for the 2nd step

#temporary output & error files
out="rose-"$NEW_UUID"-outdir"
tmp="rose-"$NEW_UUID"-tmpdir"
jobstore="rose-"$NEW_UUID"-jobstore"
logtxt="rose-"$NEW_UUID"-log.txt"
logout="rose-"$NEW_UUID"-outfile_out"
logerr="rose-"$NEW_UUID"-outfile_err"

rm -rf $jobstore $logtxt $logout $logerr

#------
###Modules & PATH update
#------
module load python/3.7.0            
module load node
module load igvtools/2.3.2
module load fastqc/0.11.5
module load bowtie/1.2.2
module load samtools/1.9
module load macs/041014
module load ucsc/041619
module load R/3.6.1
module load bedtools/2.25.0
module load meme/4.11.2
module load bedops/2.4.2
module load java/1.8.0_60
module load BAM2GFF/1.1.0
module load ROSE/1.1.0
 
export PATH=$PATH:$location/scripts

#------
###WORKFLOW
#------
##cwlexec 1st step
echo "UPDATE:  STEP1 in progress"

##work and out files
mkdir -p $tmp $out
 
##excuting step one
toil-cwl-runner --batchSystem=lsf \
--disableCaching \
--logFile $logtxt \
--jobStore $jobstore \
--clean never \
--defaultMemory 3G \
--workDir $tmp \
--cleanWorkDir never \
--outdir $out \
$script $parameters 1>$logout 2>$logerr
