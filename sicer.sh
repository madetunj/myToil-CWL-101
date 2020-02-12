#!/usr/bin/env bash
#------
###SYNTAX to run
#bsub -P watcher -q compbio -J sicer-toil -o sicer-toil_out -e sicer-toil_err -N ./sicer.sh
####

#------
###FILES
#------
location="/rgs01/project_space/abrahgrp/Software_Dev_Sandbox/common/101madetunji/ToilGettingThere"
parameters="$location/temp-parameters.yml" #$1" #inputparameters.yml"
script="$location/workflows/sicer.cwl" #ToilChipSeq-1st-mapping.cwl"

OLD_UUID=$1
NEW_UUID=${NEW_UUID:=${OLD_UUID%%.yml}} #reuse old file
NEW_UUID=${NEW_UUID:=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"_"`date +%s`} #temporary file for the 2nd step

#temporary output & error files
out="$(pwd)/sicer-"$NEW_UUID"-outdir"
tmp="$(pwd)/sicer-"$NEW_UUID"-tmpdir"
jobstore="sicer-"$NEW_UUID"-jobstore"
logtxt="sicer-"$NEW_UUID"-log.txt"
logout="sicer-"$NEW_UUID"-outfile_out"
logerr="sicer-"$NEW_UUID"-outfile_err"

rm -rf $jobstore $logtxt $logout $logerr

#------
###Modules & PATH update
#------
module load samtools/1.9
module load R/3.6.1
module load bedtools/2.25.0
 
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
--preserve-entire-environment \
--disableCaching \
--logFile $logtxt \
--jobStore $jobstore \
--clean never \
--workDir $tmp \
--cleanWorkDir never \
--outdir $out \
$script $parameters 1>$logout 2>$logerr
