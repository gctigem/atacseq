/* 2
 ##### Trimming #####
 Nextera adaptor trimming + fastqc
*/


process trimming {
    container = 'docker://dceoy/trim_galore:latest'
    echo true
    tag 'Trim Galore'
    label 'trimming'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf(".html") > 0) "trimming/postTrimQC/$filename"
      else if (filename.indexOf(".zip") > 0) "trimming/postTrimQC/zip/$filename"
      else if (filename.indexOf(".txt") > 0) "trimming/logs/$filename"
      else if (filename.indexOf(".fq.gz")) "trimming/trimmed_fastq/$filename"
      else null
        }

    input:
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path('*.fq.gz'), emit: samples_trimmed
    file '*_fastqc.{zip,html}'
    file '*.txt'

    script:
    """
    ln -s ${reads[0]} ${sample_id}_rep1_1.fastq.gz
    ln -s ${reads[1]} ${sample_id}_rep1_2.fastq.gz
    trim_galore --gzip \
        --fastqc --paired ${sample_id}_rep1_1.fastq.gz ${sample_id}_rep1_2.fastq.gz \
        --nextera \
        --length $params.length

    ln -s ${reads[2]} ${sample_id}_rep2_1.fastq.gz
    ln -s ${reads[3]} ${sample_id}_rep2_2.fastq.gz
    trim_galore --gzip \
        --fastqc --paired ${sample_id}_rep2_1.fastq.gz ${sample_id}_rep2_2.fastq.gz \
        --nextera \
        --length $params.length
    """
}