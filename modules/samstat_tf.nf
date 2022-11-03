process samstat_tf {
    container 'docker://giusmar/atacseq:0.1.1'
    echo true
    label 'samstat_tf'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep") > 0)       "samstat/third_filtering/${rep}/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(sf_sorted_bam)

    output:
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_orphanfilt.bam"), emit: tf_orphan_bam
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_third_filtering_sorted.{bam,bam.bai}"), emit: tf_sorted_bam
    tuple val(sample_id), val(rep), path("*.{flagstat,idxstats,stats}"), emit: tf_sorted_flagstat

    script:
    """
    samtools sort -n ${sf_sorted_bam} -o ${sample_id}_${rep}_sortedbyname.bam

    bampe_rm_orphan.py ${sample_id}_${rep}_sortedbyname.bam ${sample_id}_${rep}_orphanfilt.bam --only_fr_pairs

    samtools sort ${sample_id}_${rep}_orphanfilt.bam -o ${sample_id}_${rep}_third_filtering_sorted.bam
    samtools index ${sample_id}_${rep}_third_filtering_sorted.bam 
    samtools flagstat ${sample_id}_${rep}_third_filtering_sorted.bam  > ${sample_id}_${rep}_third_filtering_sorted.bam.flagstat
    samtools idxstats ${sample_id}_${rep}_third_filtering_sorted.bam > ${sample_id}_${rep}_third_filtering_sorted.bam.idxstats
    samtools stats ${sample_id}_${rep}_third_filtering_sorted.bam > ${sample_id}_${rep}_third_filtering_sorted.bam.stats
    """
}
