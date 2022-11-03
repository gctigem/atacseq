/* 7
 ##### Samstat unique bam #####
*/

process samstat_uniq {
    container 'docker://giusmar/atacseq:0.0.3'
    echo true
    label 'samstat_uniq'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep") > 0)       "samstat/uniq/${rep}/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(uniq_bam)

    output:
    tuple val(sample_id), val(rep), path("*.{bam,bai}"), emit: sorted_uniq_bam_bai
    tuple val(sample_id), val(rep), path("*.{flagstat,idxstats,stats}"), emit: sorted_uniq_stats

    script:
    """
    samtools index ${uniq_bam}
    samtools flagstat ${uniq_bam} > \
        ${sample_id}_${rep}_sorted_uniq.bam.flagstat
    samtools idxstats ${uniq_bam} > \
        ${sample_id}_${rep}_sorted_uniq.bam.idxstats
    samtools stats ${uniq_bam} > \
        ${sample_id}_${rep}_sorted_uniq.bam.stats
    """
}
