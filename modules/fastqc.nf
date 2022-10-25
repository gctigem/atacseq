process fastqc {
    echo true
    label 'fastqc'
    tag 'FASTQC'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.endsWith("_1.fastq.gz"))     "fastqc/zips/${rep}/$filename"        
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(reads)

    output:
    tuple val(sample_id), val(rep), path("*.{zip,html}"), emit: qc_multiqc

    script:
    """
    ln -s ${reads[0]} ${sample_id}_${rep}_1.fastq.gz
    ln -s ${reads[1]} ${sample_id}_${rep}_2.fastq.gz
    fastqc ${sample_id}_${rep}_1.fastq.gz
    fastqc ${sample_id}_${rep}_2.fastq.gz
    """
}