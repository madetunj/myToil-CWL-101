#!/usr/bin/env bash
#------
###SYNTAX to run
#bsub -P watcher -q compbio -J toil-cwl -o toil-cwl_out -e toil-cwl_err -N ./SubmitToilJob.sh
####

#------
###FILES
#------
location="/home/madetunj/101madetunji/ToilGettingThere"
parameters="$location/inputparameters.yml"
script="$location/workflows/Toil-chipSEQ.cwl"

#------
###Modules
#------
module load fastqc/0.11.5
module load python/3.7.0
module load python/2.7.2
module load bowtie/1.2.2
module load samtools/1.9
module load macs/041014
module load ucsc/041619
module load bedtools/2.25.0
module load meme/4.11.2
module load java/1.8.0_60

export PATH=$PATH:$location/scripts

#------
###HOUSEKEEPING
#------
#removing work and out files
rm -rf $(pwd)/workdir $(pwd)/outdir $(pwd)/jobstore $(pwd)/log.txt
mkdir $(pwd)/workdir $(pwd)/outdir

#------
###WORKFLOW
#------

##toil cwl
toil-cwl-runner --batchSystem=lsf \
--disableCaching \
--logFile log.txt \
--jobStore jobstore \
--clean never \
--defaultMemory 100M \
--maxMemory 20G \
--maxCores 20 \
--workDir $(pwd)/workdir \
--cleanWorkDir never \
--outdir $(pwd)/outdir \
$script $parameters 1>xoutfile_out 2>xoutfile_err
