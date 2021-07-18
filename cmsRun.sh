#!/bin/bash


# This script is written to submit CMSSW job in condor from recas.


RUN0=$1       # Fixed value as in the python file
RUNnew=$2     # varies with run number. Input is given by testCondor2.cond


SCRIPT=$(readlink -f "$0")					
SCRIPTPATH=$(dirname "$SCRIPT")

echo $SCRIPT
echo $SCRIPTPATH

# creating tarball of the specific directory
tar -czvf myDir.tar.gz ./CMSSW_10_2_0

mkdir -p ~/myDir$RUNnew   #Creating directory if it is not available
cd ~/myDir$RUNnew
mv /lustrehome/bkailasa/MyAnalysis/CMSSW/myDir.tar.gz .
tar -xvzf myDir.tar.gz

SCRIPT=$(readlink -f "$0")					
SCRIPTPATH=$(dirname "$SCRIPT")				
echo "CMSSW is copied to" $SCRIPTPATH

cd CMSSW_10_2_0/src

SCRIPT=$(readlink -f "$0")					
SCRIPTPATH=$(dirname "$SCRIPT")				
echo "Now you are in" $SCRIPTPATH

sed "s/$RUN0/$RUNnew/" ./FastjetEx/FastJetSimple1/python/FastJetSimple1.py > ./FastjetEx/FastJetSimple1/python/FastJetSimple$RUNnew.py
# Above command open FastJetSimple1.py and replaces initial run nu to new run number and save it as a new file.


#Exporting CMSSW environment here

export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
$VO_CMS_SW_DIR/cmsset_default.sh
grep cmsrel $VO_CMS_SW_DIR/cmsset_default.sh
source $VO_CMS_SW_DIR/cmsset_default.sh



#configuring CMSSW environment 
#-----------------------------
eval `scram runtime -sh`            # alias of this command is the cmsenv. Here we cannot use alias.

scram b

# Now we are here: ~/myDir$RUNnew/CMSSW_10_2_0/src/

cmsRun ./FastjetEx/FastJetSimple1/python/FastJetSimple$RUNnew.py

exit 0
