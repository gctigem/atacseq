process j_coefficient {
    echo true
    label 'j_coefficient'
    tag 'BEDTOOLS'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("jaccard") > 0)       "jaccard/peakcalling_sorted/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(narrowPeak)

    output:
    tuple val(sample_id), path("*.sorted.narrowPeak"), emit: sorted_peak
    tuple val(sample_id), path("*.jaccard"), emit: jaccard
    tuple val(sample_id), path("*.jaccard_score_mqc.tsv"), emit: jaccard_score_mqc

    script:
    """
    sort -k1,1 -k2,2n ${narrowPeak} > ${sample_id}_${rep}_peaks.sorted.narrowPeak

    bedtools jaccard -a ${sample_id}_rep1_peaks.sorted.narrowPeak -b ${sample_id}_rep2_peaks.sorted.narrowPeak > ${sample_id}_rep1_rep2.jaccard
    cat ${sample_id}_rep1_rep2.jaccard | awk -v OFS='\t' -v name=${sample_id} 'FNR == 2 {print name, \$3}' | cat $baseDir/assets/$params.jaccard_score - > ${sample_id}_pulled_peaks.jaccard_score_mqc.tsv
    """
}