/* 
 ##### Jaccard  #####
 Jaccard coefficient among biological replicates peaks
*/

process j_coefficient {
    container 'docker://giusmar/atacseq:0.0.6'
    echo true
    label 'j_coefficient'
    tag 'bedtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "jaccard/peakcalling_sorted/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "jaccard/peakcalling_sorted/rep2/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(narrowPeak)

    output:
    tuple val(sample_id), path("*.sorted.narrowPeak"), emit: sorted_peak
    tuple val(sample_id), path("*.jaccard"), emit: jaccard
    tuple val(sample_id), path("*.jaccard_score_mqc.tsv"), emit: jaccard_score_mqc

    script:
    """
    sort -k1,1 -k2,2n ${narrowPeak[0]} > ${sample_id}_rep1_peaks.sorted.narrowPeak
    sort -k1,1 -k2,2n ${narrowPeak[1]} > ${sample_id}_rep2_peaks.sorted.narrowPeak

    bedtools jaccard -a ${sample_id}_rep1_peaks.sorted.narrowPeak -b ${sample_id}_rep2_peaks.sorted.narrowPeak > ${sample_id}_rep1_rep2.jaccard
    cat ${sample_id}_rep1_rep2.jaccard | awk -v OFS='\t' -v name=${sample_id} 'FNR == 2 {print name, \$3}' | cat $baseDir/assets/$params.jaccard_score - > ${sample_id}_pulled_peaks.jaccard_score_mqc.tsv
    """
}