/* 
 ##### Samstat third filtering #####
*/

process samstat_tf {
    container 'docker://giusmar/atacseq:0.0.3'
    echo true
    label 'samstat_tf'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "samstat/third_filtering/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "samstat/third_filtering/rep2/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(sf_sorted_bam)
    //tuple val(sample_id), path(sf_sorted_bai)

    output:
    tuple val(sample_id), path("*.orphanfilt.bam"), emit: tf_orphan_bam
    tuple val(sample_id), path("*.third_filtering.sorted.bam"), emit: tf_sorted_bam
    tuple val(sample_id), path("*.flagstat"), emit: tf_sorted_flagstat
    tuple val(sample_id), path("*.idxstats")
    tuple val(sample_id), path("*.stats")
    path("*.third_filtering.sorted.bam"), emit: bam

    script:
    """
    samtools sort -n ${sf_sorted_bam[0]} -o ${sample_id}_rep1.sortedbyname.bam

    bampe_rm_orphan.py ${sample_id}_rep1.sortedbyname.bam ${sample_id}_rep1.orphanfilt.bam --only_fr_pairs

    samtools sort ${sample_id}_rep1.orphanfilt.bam -o ${sample_id}_rep1.third_filtering.sorted.bam
    samtools index ${sample_id}_rep1.third_filtering.sorted.bam 
    samtools flagstat ${sample_id}_rep1.third_filtering.sorted.bam  > ${sample_id}_rep1.third_filtering.sorted.bam.flagstat
    samtools idxstats ${sample_id}_rep1.third_filtering.sorted.bam > ${sample_id}_rep1.third_filtering.sorted.bam.idxstats
    samtools stats ${sample_id}_rep1.third_filtering.sorted.bam > ${sample_id}_rep1.third_filtering.sorted.bam.stats
    
    rm ${sf_sorted_bam[0]} 

    samtools sort -n ${sf_sorted_bam[1]} -o ${sample_id}_rep2.sortedbyname.bam
    
    bampe_rm_orphan.py ${sample_id}_rep2.sortedbyname.bam ${sample_id}_rep2.orphanfilt.bam --only_fr_pairs

    samtools sort ${sample_id}_rep2.orphanfilt.bam -o ${sample_id}_rep2.third_filtering.sorted.bam
    samtools index ${sample_id}_rep2.third_filtering.sorted.bam 
    samtools flagstat ${sample_id}_rep2.third_filtering.sorted.bam  > ${sample_id}_rep2.third_filtering.sorted.bam.flagstat
    samtools idxstats ${sample_id}_rep2.third_filtering.sorted.bam > ${sample_id}_rep2.third_filtering.sorted.bam.idxstats
    samtools stats ${sample_id}_rep2.third_filtering.sorted.bam > ${sample_id}_rep2.third_filtering.sorted.bam.stats
    
    rm ${sf_sorted_bam[1]}
    """
}
