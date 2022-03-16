/* 7
 ##### Samstat unique bam #####
*/

process samstat_uniq {
    echo true
    label 'samstat_uniq'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "samstat/uniq/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "samstat/uniq/rep2/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(uniq_bam)

    output:
    tuple val(sample_id), path("*.{bam,bai}"), emit: sorted_uniq_bai
    tuple val(sample_id), path("*.flagstat"), emit: sorted_uniq_flagstat
    tuple val(sample_id), path("*.idxstats")
    tuple val(sample_id), path("*.stats")

    script:
    """
    samtools index ${uniq_bam[0]}
    samtools flagstat ${uniq_bam[0]} > \
        ${sample_id}_rep1.sorted.uniq.bam.flagstat
    samtools idxstats ${uniq_bam[0]} > \
        ${sample_id}_rep1.sorted.uniq.bam.idxstats
    samtools stats ${uniq_bam[0]} > \
        ${sample_id}_rep1.sorted.uniq.bam.stats

    samtools index ${uniq_bam[1]}
    samtools flagstat ${uniq_bam[1]} > \
        ${sample_id}_rep2.sorted.uniq.bam.flagstat
    samtools idxstats ${uniq_bam[1]} > \
        ${sample_id}_rep2.sorted.uniq.bam.idxstats
    samtools stats ${uniq_bam[1]} > \
        ${sample_id}_rep2.sorted.uniq.bam.stats
    """
}
