/* 
 ##### Peak calling and FRiP calculation  #####
*/

process peak_calling {
    echo true
    label 'peak_calling'
    tag 'Python'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "macs2/peakcalling/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "macs2/peakcalling/rep2/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(fragment_bed), path(tf_sorted_bam), path(tf_sorted_flagstat)

    output:
    tuple val(sample_id), path("*_peaks.narrowPeak"), emit: narrowPeak
    tuple val(sample_id), path("*.count_mqc.tsv"), emit: count_mqc
    tuple val(sample_id), path("*.FRiP_mqc.tsv"), emit: frip_mqc

    script:
    READS_IN_PEAKS_rep1 = "bedtools intersect -a ${sample_id}_rep1.third_filtering.sorted.bam -b ${sample_id}_rep1_peaks.narrowPeak -bed -c -f 0.20 | awk -F '\t' '{sum += \$NF} END {print sum}'"
    READS_IN_PEAKS_rep2 = "bedtools intersect -a ${sample_id}_rep2.third_filtering.sorted.bam -b ${sample_id}_rep2_peaks.narrowPeak -bed -c -f 0.20 | awk -F '\t' '{sum += \$NF} END {print sum}'"
    """
    macs2 callpeak -t ${fragment_bed[0]} -n ${sample_id}_rep1 -f BEDPE
    cat ${sample_id}_rep1_peaks.narrowPeak | wc -l | awk -v OFS='\t' -v name="${sample_id}" '{ print name, \$1 }' | cat $params.mlib_peak_count_header - > ${sample_id}_rep1_peaks.count_mqc.tsv
    grep 'mapped (' ${tf_sorted_flagstat[0]} | awk -v a="${READS_IN_PEAKS_rep1}" -v OFS='\t' -v name="${sample_id}" '{print name, a/\$1}' | cat $params.mlib_frip_score_header - > ${sample_id}_rep1_peaks.FRiP_mqc.tsv

    macs2 callpeak -t ${fragment_bed[1]} -n ${sample_id}_rep2 -f BEDPE
    cat ${sample_id}_rep2_peaks.narrowPeak | wc -l | awk -v OFS='\t' -v name="${sample_id}" '{ print name, \$1 }' | cat $params.mlib_peak_count_header - > ${sample_id}_rep2_peaks.count_mqc.tsv
    grep 'mapped (' ${tf_sorted_flagstat[1]} | awk -v a="${READS_IN_PEAKS_rep2}" -v OFS='\t' -v name="${sample_id}" '{print name, a/\$1}' | cat $params.mlib_frip_score_header - > ${sample_id}_rep2_peaks.FRiP_mqc.tsv
    """
}