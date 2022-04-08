/* 6
 ##### Remove dups #####
*/

process remove_dups {
    container 'docker://circleci/picard:latest'
    echo true
    label 'remove_dups'
    tag 'Picard'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("bam") > 0)       "picard/$filename"
        else if (filename.indexOf("txt") > 0)       "picard/metrics/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("*.sorted.uniq.bam"), emit: uniq_bam
    tuple val(sample_id), path("*.metrics.txt"), emit: uniq_txt

    script:
    """
    picard MarkDuplicates INPUT=${bam[0]} OUTPUT=${sample_id}_rep1.sorted.uniq.bam ASSUME_SORTED=true REMOVE_DUPLICATES=true METRICS_FILE=${sample_id}_rep1.MarkDuplicates.metrics.txt VALIDATION_STRINGENCY=LENIENT
    
    rm ${bam[0]}
    
    picard MarkDuplicates INPUT=${bam[1]} OUTPUT=${sample_id}_rep2.sorted.uniq.bam ASSUME_SORTED=true REMOVE_DUPLICATES=true METRICS_FILE=${sample_id}_rep2.MarkDuplicates.metrics.txt VALIDATION_STRINGENCY=LENIENT
    
    rm ${bam[1]}
    """
}
