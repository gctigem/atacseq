process peak_calling {
    echo true
    label 'peak_calling'
    tag 'MACS3'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("narrow") > 0)       "macs3/peakcalling/${rep}/peak/$filename"
        else if (filename.indexOf("tsv") > 0)       "macs3/peakcalling/${rep}/tsv/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(fragment_bed), path(tf_sorted_bam), path(tf_sorted_flagstat)

    output:
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_peaks.narrowPeak"), emit: narrowPeak
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_peaks.count_mqc.tsv"), emit: count_mqc
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_peaks.FRiP_mqc.tsv"), emit: frip_mqc

    script:
    READS_IN_PEAKS = "bedtools intersect -a ${tf_sorted_bam} -b ${sample_id}_${rep}_peaks.narrowPeak -bed -c -f 0.20 | awk -F '\t' '{sum += \$NF} END {print sum}'"
    """
    singularity exec /home/tigem/s.slovin/singularity/cachedir/atacseq-0.1.6.simg macs3 callpeak -t ${fragment_bed} -n ${sample_id}_${rep} -f BEDPE
    cat ${sample_id}_${rep}_peaks.narrowPeak | wc -l | awk -v OFS='\t' -v name="${sample_id}" '{ print name, \$1 }' | \\
     cat $baseDir/assets/$params.mlib_peak_count_header - > ${sample_id}_${rep}_peaks.count_mqc.tsv
    grep 'mapped (' ${tf_sorted_flagstat[0]} | awk -v a="${READS_IN_PEAKS}" -v OFS='\t' -v name="${sample_id}" '{print name, a/\$1}' | \\
     cat $baseDir/assets/$params.mlib_frip_score_header - > ${sample_id}_${rep}_peaks.FRiP_mqc.tsv
    """
}