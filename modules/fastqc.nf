/* 1
 ##### FASTQC #####
*/

process fastqc {
    container 'docker://staphb/fastqc:0.11.9'
    echo true
    label 'fastqc'
    tag 'FASTQC'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("zip") > 0)     "fastqc/zips/$filename"
        else if (filename.indexOf("html") > 0)    "fastqc/$filename"            
        else null            
    }

    input:
    tuple val(sample_id), path(reads)

    output:
    file  "*.{zip,html}"

    script:
    """
    ln -s ${reads[0]} ${sample_id}_rep1_1.fastq.gz
    ln -s ${reads[1]} ${sample_id}_rep1_2.fastq.gz
    fastqc ${sample_id}_rep1_1.fastq.gz
    fastqc ${sample_id}_rep1_2.fastq.gz
    
    ln -s ${reads[2]} ${sample_id}_rep2_1.fastq.gz
    ln -s ${reads[3]} ${sample_id}_rep2_2.fastq.gz
    fastqc ${sample_id}_rep2_1.fastq.gz
    fastqc ${sample_id}_rep2_2.fastq.gz
    """
}