#!/bin/bash
#
# Master script for processing PolII bed files 
# This version created for noncoding RNAs, eg. RefSeq NR_ prefix
# Works for TSV file generation, but not for .RData files, as 
# the .Rs for those have the directory "processed_data" written in to the code
#

#
# PolII gene overlap 
#
if [ ! -e ~/chipseq/processed_data_nr/PolII ]
then
    mkdir ~/chipseq/processed_data_nr/PolII
fi
cd ~/chipseq/processed_data_nr/PolII
~/chipseq/utils/GenomicFeatureChIPSeqOverlapMetaWrapper.sh ~/chipseq/auxfiles/PolIIbedfiles ~/chipseq/data/PolII/bed/ ~/chipseq/annotation/refGene.mouse.bed NR_
sed 's/bed/olap.tsv/g' ~/chipseq/auxfiles/PolIIbedfiles > infiles
~/bin/R/CombineColumnsToMatrix.sh infiles .olap.tsv 2 PolII-olap.tsv 0 RefSeq
~/chipseq/utils/expandNMannots.sh PolII-olap.tsv ~/chipseq/annotation/refGene.mouse.bed PolII-olap.annot.tsv
rm -f infiles

~/chipseq/utils/SignalSummaryWrapper.sh ~/chipseq/auxfiles/PolIIbedfiles /Volumes/CancerRegulome9/workspaces/users/vthorsson/ChIPSeq_Analysis/PeakFiles/ ~/chipseq/annotation/refGene.mouse.bed NR_
sed 's/bed/signalsummary.tsv/g' ~/chipseq/auxfiles/PolIIbedfiles > infiles
~/bin/R/CombineColumnsToMatrix.sh infiles .signalsummary.tsv 2 PolII-signal.tsv 0 RefSeq
~/chipseq/utils/expandNMannots.sh PolII-signal.tsv ~/chipseq/annotation/refGene.mouse.bed PolII-signal.annot.tsv
rm -f infiles

#
# PolII overlap with 5kb upstream
#
if [ ! -e ~/chipseq/processed_data_nr/PolIIupstream5kb ]
then
    mkdir ~/chipseq/processed_data_nr/PolIIupstream5kb
fi
cd ~/chipseq/processed_data_nr/PolIIupstream5kb
~/chipseq/utils/GenomicFeatureChIPSeqOverlapMetaWrapper.sh ~/chipseq/auxfiles/PolIIbedfiles ~/chipseq/data/PolII/bed/ ~/chipseq/annotation/refGene.mouse.upstream5kb.bed NR_
sed 's/bed/olap.tsv/g' ~/chipseq/auxfiles/PolIIbedfiles > infiles
~/bin/R/CombineColumnsToMatrix.sh infiles .olap.tsv 2 PolIIupstream5kb-olap.tsv 0 RefSeq
~/chipseq/utils/expandNMannots.sh PolIIupstream5kb-olap.tsv ~/chipseq/annotation/refGene.mouse.bed PolIIupstream5kb-olap.annot.tsv
rm -f infiles

#
# PolII overlap with 5kb downstream
#
if [ ! -e ~/chipseq/processed_data_nr/PolIIdownstream5kb ]
then
    mkdir ~/chipseq/processed_data_nr/PolIIdownstream5kb
fi
cd ~/chipseq/processed_data_nr/PolIIdownstream5kb
~/chipseq/utils/GenomicFeatureChIPSeqOverlapMetaWrapper.sh ~/chipseq/auxfiles/PolIIbedfiles ~/chipseq/data/PolII/bed/ ~/chipseq/annotation/refGene.mouse.downstream5kb.bed NR_
sed 's/bed/olap.tsv/g' ~/chipseq/auxfiles/PolIIbedfiles > infiles
~/bin/R/CombineColumnsToMatrix.sh infiles .olap.tsv 2 PolIIdownstream5kb-olap.tsv 0 RefSeq
~/chipseq/utils/expandNMannots.sh PolIIdownstream5kb-olap.tsv ~/chipseq/annotation/refGene.mouse.bed PolIIdownstream5kb-olap.annot.tsv
rm -f infiles


#
#  Characterize peak closest to TSS
#

if [ ! -e ~/chipseq/processed_data_nr/PolIInearTSS ]
then
    mkdir ~/chipseq/processed_data_nr/PolIInearTSS
fi
cd ~/chipseq/processed_data_nr/PolIInearTSS

~/chipseq/utils/PeakNearTSSMetaWrapper.sh ~/chipseq/auxfiles/PolIIbedfiles ~/chipseq/data/PolII/bed/ ~/chipseq/annotation/refGene.mouse.bed ~/chipseq/annotation/refGene.mouse.10kbridge.bed NR_
sed 's/bed/neartss.tsv/g' ~/chipseq/auxfiles/PolIIbedfiles > infiles
~/bin/R/CombineColumnsToMatrix.sh infiles .neartss.tsv 1 PolII-distfromtss.tsv NA RefSeq
~/chipseq/utils/expandNMannots.sh PolII-distfromtss.tsv ~/chipseq/annotation/refGene.mouse.bed PolII-distfromtss.annot.tsv
~/bin/R/CombineColumnsToMatrix.sh infiles .neartss.tsv 2 PolII-widthneartss.tsv NA RefSeq
~/chipseq/utils/expandNMannots.sh PolII-widthneartss.tsv ~/chipseq/annotation/refGene.mouse.bed PolII-widthneartss.annot.tsv
~/bin/R/CombineColumnsToMatrix.sh infiles .neartss.tsv 3 PolII-boundarytotss.tsv NA RefSeq
~/chipseq/utils/expandNMannots.sh PolII-boundarytotss.tsv ~/chipseq/annotation/refGene.mouse.bed PolII-boundarytotss.annot.tsv
~/bin/R/CombineColumnsToMatrix.sh infiles .neartss.tsv 4 PolII-scoreneartss.tsv NA RefSeq
~/chipseq/utils/expandNMannots.sh PolII-scoreneartss.tsv ~/chipseq/annotation/refGene.mouse.bed PolII-scoreneartss.annot.tsv
rm -f infiles

##
## Create RData versions of the above
## 

cd ~/chipseq/processed_data_nr
R --no-save < ../utils/polIIFracolap.R
R --no-save < ../utils/polIISignal.R
R --no-save < ../utils/polIInearTSS.R




