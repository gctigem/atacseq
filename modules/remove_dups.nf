process remove_dups {
    echo true
    label 'remove_dups'
    tag 'PICARD'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("bam") > 0)       "picard/${rep}/$filename"
        else if (filename.indexOf("txt") > 0)       "picard/${rep}/metrics/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(sorted_bam)

    output:
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_sorted_uniq.bam"), emit: uniq_bam
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_MarkDuplicates_metrics.txt"), emit: uniq_txt

    script:
    def avail_mem = 60
    """
    java -Xmx${avail_mem}g -jar /picard.jar MarkDuplicates INPUT=${sorted_bam[0]} OUTPUT=${sample_id}_${rep}_sorted_uniq.bam ASSUME_SORTED=true REMOVE_DUPLICATES=true METRICS_FILE=${sample_id}_${rep}_MarkDuplicates_metrics.txt VALIDATION_STRINGENCY=LENIENT
    """
}
