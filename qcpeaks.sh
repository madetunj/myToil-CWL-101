#!/usr/bin/env bash
#------
###SYNTAX to run
#bsub -P watcher -q compbio -J qcpeaks-toil -o qcpeaks-toil_out -e qcpeaks-toil_err -N ./qcpeaks.sh
####

#------
###FILES
#------
location="/rgs01/project_space/abrahgrp/Software_Dev_Sandbox/common/101madetunji/ToilGettingThere"
parameters="$location/temp-parameters.yml" #$1" #inputparameters.yml"
script="$location/workflows/qcpeaks.cwl" #ToilChipSeq-1st-mapping.cwl"

OLD_UUID=$1
NEW_UUID=${NEW_UUID:=${OLD_UUID%%.yml}} #reuse old file
NEW_UUID=${NEW_UUID:=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)"_"`date +%s`} #temporary file for the 2nd step

#temporary output & error files
out="$(pwd)/qcpeaks-"$NEW_UUID"-outdir"
tmp="$(pwd)/qcpeaks-"$NEW_UUID"-tmpdir"
jobstore="qcpeaks-"$NEW_UUID"-jobstore"
logtxt="qcpeaks-"$NEW_UUID"-log.txt"
logout="qcpeaks-"$NEW_UUID"-outfile_out"
logerr="qcpeaks-"$NEW_UUID"-outfile_err"

rm -rf $jobstore $logtxt $logout $logerr

#------
###Modules & PATH update
#------
module load R/3.6.1 
module load bedtools/2.25.0
module load bedops/2.4.2

export PATH=$PATH:$location/scripts
which python
which R

#------
###HOUSEKEEPING
#------
mkdir -p $tmp $out

#------
###WORKFLOW
#------
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
