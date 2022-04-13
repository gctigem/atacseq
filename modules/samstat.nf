/* 4
 ##### Sam stat #####
*/

process samstat {
    container 'docker://giusmar/atacseq:0.0.3'
    echo true
    label 'samstat'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "samstat/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "samstat/rep2/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("*.bam"), emit: sorted_bam
    tuple val(sample_id), path("*.flagstat"), emit: sam_flagstat
    tuple val(sample_id), path("*.idxstats")
    tuple val(sample_id), path("*.stats")

    script:
    """
    samtools sort ${bam[0]} -O bam -o ${sample_id}_rep1.sorted.bam
    samtools flagstat ${sample_id}_rep1.sorted.bam > \
        ${sample_id}_rep1.sorted.bam.flagstat
    samtools idxstats ${sample_id}_rep1.sorted.bam > \
        ${sample_id}_rep1.sorted.bam.idxstats
    samtools stats ${sample_id}_rep1.sorted.bam > \
        ${sample_id}_rep1.sorted.bam.stats
        
    rm ${bam[0]}

    samtools sort ${bam[1]} -O bam -o ${sample_id}_rep2.sorted.bam
    samtools flagstat ${sample_id}_rep2.sorted.bam > \
        ${sample_id}_rep2.sorted.bam.flagstat
    samtools idxstats ${sample_id}_rep2.sorted.bam > \
        ${sample_id}_rep2.sorted.bam.idxstats
    samtools stats ${sample_id}_rep2.sorted.bam > \
        ${sample_id}_rep2.sorted.bam.stats
        
    rm ${bam[1]}
    """
}
