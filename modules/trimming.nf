process trimming {
    echo true
    tag 'TRIMGALORE'
    label 'trimming'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf(".html") > 0) "trimming/postTrimQC/$filename"
      else null
        }

    input:
    tuple val(sample_id), val(rep), path(reads)
    
    // output:
    // tuple val(sample_id), path('*.fq.gz'), emit: samples_trimmed
    // tuple val(sample_id), path('*_fastqc.{zip,html}')
    // tuple val(sample_id), path('*.txt')

    script:
    """
    ln -s ${reads[0]} ${sample_id}_rep1_1.fastq.gz
    ln -s ${reads[1]} ${sample_id}_rep1_2.fastq.gz
    trim_galore --gzip \
        --fastqc --paired ${sample_id}_rep1_1.fastq.gz ${sample_id}_rep1_2.fastq.gz \
        --nextera \
        --length $params.trimgalore_length
    """
}