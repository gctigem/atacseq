process trimming {
    echo true
    tag 'TRIMGALORE'
    label 'trimming'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf(".html") > 0)     "trim_galore/${rep}/qc/$filename"
        else if (filename.indexOf("val") > 0)       "trim_galore/${rep}/fastq/$filename"
        else if (filename.indexOf("trimming_report") > 0)       "trim_galore/${rep}/report/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(reads)
    
    output:
    tuple val(sample_id), val(rep), path("*.{zip,html}"), emit: qc_multiqc
    tuple val(sample_id), val(rep), path("*report.txt"), emit: report
    tuple val(sample_id), val(rep), path("*val_{1,2}.fq.gz"), emit: fastq

    script:
    """
    ln -s ${reads[0]} ${sample_id}_${rep}_1.fastq.gz
    ln -s ${reads[1]} ${sample_id}_${rep}_2.fastq.gz
    trim_galore --gzip \
        --fastqc --paired ${sample_id}_${rep}_1.fastq.gz ${sample_id}_${rep}_2.fastq.gz \
        --nextera \
        --length $params.trimgalore_length
    """
}