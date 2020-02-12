#!/usr/bin/env bash
#------
###SYNTAX to run
#bsub -P watcher -q compbio -J mgene_toil -o mgene_toil_out -e mgene_toil_err -N ./metagene.sh
####

#------
###FILES
#------
location="/rgs01/project_space/abrahgrp/Software_Dev_Sandbox/common/101madetunji/ToilGettingThere"
parameters="$location/temp-parameters.yml"
script="$location/workflows/metagene.cwl"

OLD_UUID=$1
NEW_UUID=${NEW_UUID:=${OLD_UUID%%.yml}} #reuse old file
NEW_UUID=${NEW_UUID:=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"_"`date +%s`} #temporary file for the 2nd step

#temporary output & error files
out="$(pwd)/mgene-"$NEW_UUID"-outdir"
tmp="$(pwd)/mgene-"$NEW_UUID"-tmpdir"
jobstore="mgene-"$NEW_UUID"-jobstore"
logtxt="mgene-"$NEW_UUID"-log.txt"
logout="mgene-"$NEW_UUID"-outfile_out"
logerr="mgene-"$NEW_UUID"-outfile_err"

#------
###Modules & PATH update
#------
module load python/3.7.0            
module load R/3.6.1
module load bedtools/2.25.0
module load BAM2GFF/1.1.0
module load ROSE/1.1.0
 
export PATH=$PATH:$location/scripts

#------
###WORKFLOW
#------
mkdir -p $tmp $out
toil-cwl-runner --batchSystem=lsf \
--disableCaching \
--logFile $logtxt \
--jobStore $jobstore \
--clean never \
--workDir $tmp \
--cleanWorkDir never \
--outdir $out \
$script $parameters 1>$logout 2>$logerr
