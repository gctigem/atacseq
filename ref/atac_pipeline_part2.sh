#### IDR peaks ####

# 1 #
# Create a consensus peak-set across all samples 

## first we presort your data by chromosome and then by start position and creat consensuse peak file across all conditions
#sample_list=`ls /home/users/s.slovin/scratch/ATAC_seq/TF300_ATAC/*/peakcalling/*_PooledIn*.narrowPeak | sort | uniq | tr '\n' ' '`
sample_list=`ls /home/users/s.slovin/scratch/ATAC_seq/TF300_ATAC/new_res/IDR_res/*/*_IDR_filtered.bed | grep -E -w "ALX1|ALX3|ARNT2|ARNTL2|ASCL1|ATF5|ATOH1|BATF|BCL6B|BHLHA15|BHLHE23|CREB3|CREB3L3|CREB5|DLX5|DRGX|EOMES|ETS2|ETV1|FEV|FOXA2|FOXA3|FOXQ1|FOXR2|GATA5|GFP2Aa|GFP2Ba|GFP2Bb|GFP3A|GFP3B|GRHL3|GSC|HAND1|HAND2|HES1|HES2|HES3|HES6|HESX1|HEY1|HEY2|HEYL|HIF1A|HLF|HMX1|HNF1A|HNF1B|HNF4G|HOXA1|HOXA5|HOXA6|HOXA7|HOXB6|HOXB7|HOXC12|HOXC4|HOXD4|ID1|IKZF1|IKZF3|IRF5|IRF8|IRF9|IRX6|JUN|JUNB|KLF1|LHX6|LHX8|LMX1B|MAFB|MEF2A|MEF2B|MEF2C|MEOX2|MESP1|MESP2|MIXL1|MYF5|MYOD1|MYOG|NEUROD1|NEUROD6|NEUROG1|NEUROG2|NEUROG3|NFATC3|NFE2|NFE2L3|NKX2-5|NKX2-8|NR2C1|NR3C2|NR4A1|NR4A2|NR5A2|OLIG1|OLIG2|OLIG3|ONECUT1|OVOL1|PAX3|PAX5|PAX7|PAX8|PAX9|PITX1|PITX2|POU2AF1|POU5F1|POU5F2|PPARA|PPARG|PRDM1|RARB|RBAK|REL|RFX3|RFX6|RHOXF2|RORB|RUNX3|SHOXF2|SIM2|SIX2|SMAD1|SNAI1|SNAI2|SOHLH1|SOX2|SPDEF|SPI1|SPIB|SPIC|TAL1|TAL2|TBX20|TBX22|TCF12|TCF7L1|TEF|TFAP2A|TFAP2B|TFAP2C|THAP2|TP63|USF1|UTF|VENTX|VSX1|VSX2|ZNF181|ZNF211|ZNF227|ZNF280A|ZNF461|ZNF483|ZNF705D|ZNF77|ZSCAN5A"` 

cat $sample_list | sort -k1,1 -k2,2n | ${bedtools} merge -i stdin > ${wd}/new_res/IDR_res/300TF_merged_peaks_160_IDR_peaks.bed

## create a bed file format which is sutible as input for HOMER
awk -v OFS='\t' 'BEGIN{FS=OFS="\t";print "Chr\tStart\tEnd\tPeakID\tignor\tStrand"} {print $1, $2, $3,"TF_peak_"NR ,"Shaked", "."}' ${wd}/new_res/IDR_res/300TF_merged_peaks_160_IDR_peaks.bed > ${wd}/new_res/IDR_res/300TF_merged_peaks_homer_160_IDR_peaks.bed

# 2 #
# Annotate peaks with homer 
export PATH=$PATH:/opt/software/ngs/homer/bin/
perl ${annotatePeaks} ${wd}/new_res/IDR_res/300TF_merged_peaks_homer_160_IDR_peaks.bed ${fasta} -gid -gtf ${hg38cr_gtf} -cpu 8 > ${wd}/new_res/IDR_res/annotatePeaks_homer_names_160_IDR_peaks.txt
 

# 3 #
# Create SAF file for featurecounts
## remove the first line with the headers
sed -i '1d' ${wd}/new_res/IDR_res/300TF_merged_peaks_homer_160_IDR_peaks.bed

## Create SAF file (+1 because SAF is 1-based, BED/narrowPeak is 0-based)
awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' ${wd}/new_res/IDR_res/300TF_merged_peaks_homer_160_IDR_peaks.bed > ${wd}/new_res/IDR_res/TF300_merged_peaks_160_IDR_peaks.saf

# 4 #
# featurecounts
sample_list=`ls /home/novaworkspace/slovin/TF_ATAC/bam_TF300/*/aln/*.third_filtering.sorted.bam | grep -E -w "ALX1|ALX3|ARNT2|ARNTL2|ASCL1|ATF5|ATOH1|BATF|BCL6B|BHLHA15|BHLHE23|CREB3|CREB3L3|CREB5|DLX5|DRGX|EOMES|ETS2|ETV1|FEV|FOXA2|FOXA3|FOXQ1|FOXR2|GATA5|GFP2Aa|GFP2Ba|GFP2Bb|GFP3A|GFP3B|GRHL3|GSC|HAND1|HAND2|HES1|HES2|HES3|HES6|HESX1|HEY1|HEY2|HEYL|HIF1A|HLF|HMX1|HNF1A|HNF1B|HNF4G|HOXA1|HOXA5|HOXA6|HOXA7|HOXB6|HOXB7|HOXC12|HOXC4|HOXD4|ID1|IKZF1|IKZF3|IRF5|IRF8|IRF9|IRX6|JUN|JUNB|KLF1|LHX6|LHX8|LMX1B|MAFB|MEF2A|MEF2B|MEF2C|MEOX2|MESP1|MESP2|MIXL1|MYF5|MYOD1|MYOG|NEUROD1|NEUROD6|NEUROG1|NEUROG2|NEUROG3|NFATC3|NFE2|NFE2L3|NKX2-5|NKX2-8|NR2C1|NR3C2|NR4A1|NR4A2|NR5A2|OLIG1|OLIG2|OLIG3|ONECUT1|OVOL1|PAX3|PAX5|PAX7|PAX8|PAX9|PITX1|PITX2|POU2AF1|POU5F1|POU5F2|PPARA|PPARG|PRDM1|RARB|RBAK|REL|RFX3|RFX6|RHOXF2|RORB|RUNX3|SHOXF2|SIM2|SIX2|SMAD1|SNAI1|SNAI2|SOHLH1|SOX2|SPDEF|SPI1|SPIB|SPIC|TAL1|TAL2|TBX20|TBX22|TCF12|TCF7L1|TEF|TFAP2A|TFAP2B|TFAP2C|THAP2|TP63|USF1|UTF|VENTX|VSX1|VSX2|ZNF181|ZNF211|ZNF227|ZNF280A|ZNF461|ZNF483|ZNF705D|ZNF77|ZSCAN5A"`
saf=${wd}/new_res/IDR_res/TF300_merged_peaks_160_IDR_peaks.saf
${featureCounts} -F SAF -O --fracOverlap 0.2 -T 14 -p -a $saf -o ${wd}/new_res/IDR_res/TF300_160_IDR_peaks.featureCounts.txt $sample_list

# fracOverlap-Minimum fraction of overlapping bases in a read that is required for read assignment