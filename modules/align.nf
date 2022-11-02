process align {
    echo true
    label 'alignment'
    tag 'BWA'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("sam") > 0)     "align/mapped/$filename"
        else null            
    }

    input:
    tuple path(fasta), path(index)
    tuple val(sample_id), val(rep), path(reads)

    output:
    tuple val(sample_id), val(rep), path('*.sam'), emit: mapped

    script:
    """
    bwa mem -M ${fasta} ${reads[0]} ${reads[1]} -o ${sample_id}_${rep}_aligned_reads.sam
    """
}
