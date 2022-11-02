process samstat {
    echo true
    label 'samstat'
    tag 'SAMTOOLS'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("stats") > 0)     "samstat/${rep}/stats/$filename"
        else if (filename.endsWith("sorted.bam"))   "samstat/${rep}/sorted/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(mapped)

    output:
    tuple val(sample_id), val(rep), path("*.bam"), emit: sorted_bam
    // tuple val(sample_id), val(rep), path("*.{flagstat,idxstats,stats}"), emit: stats

    script:
    """
    samtools view -b -h -F 0x0100 ${mapped} | samtools sort -O bam -o ${sample_id}_${rep}.sorted.bam -
    """
}
