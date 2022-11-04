process j_coefficient {
    echo true
    label 'j_coefficient'
    tag 'BEDTOOLS'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.endsWith("jaccard"))       "jaccard/peakcalling_sorted/$filename"
        else if (filename.indexOf("mqc"))       "jaccard/peakcalling_sorted/mqc/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(narrowPeak)

    output:
    tuple val(sample_id), val(rep), path("${sample_id}_${rep[0]}_peaks.sorted.narrowPeak"), emit: sorted_peak
    tuple val(sample_id), val(rep), path("${sample_id}_${rep[0]}_${rep[1]}.jaccard"), emit: jaccard
    tuple val(sample_id), val(rep), path("${sample_id}_pulled_peaks.jaccard_score_mqc.tsv"), emit: jaccard_score_mqc

    script:
    """
    sort -k1,1 -k2,2n ${narrowPeak[0]} > ${sample_id}_${rep[0]}_peaks.sorted.narrowPeak
    sort -k1,1 -k2,2n ${narrowPeak[1]} > ${sample_id}_${rep[1]}_peaks.sorted.narrowPeak

    bedtools jaccard -a ${sample_id}_${rep[0]}_peaks.sorted.narrowPeak \\
        -b ${sample_id}_${rep[1]}_peaks.sorted.narrowPeak > \\
        ${sample_id}_${rep[0]}_${rep[1]}.jaccard

    cat ${sample_id}_${rep[0]}_${rep[1]}.jaccard | \\
        awk -v OFS='\t' -v name=${sample_id} 'FNR == 2 {print name, \$3}' | \\
        cat $baseDir/assets/$params.jaccard_score - > ${sample_id}_pulled_peaks.jaccard_score_mqc.tsv
    """
}