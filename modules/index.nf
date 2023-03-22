process index {
    container 'docker://rosadesa/ampliseq:0.2'
    echo true
    label 'index'
    tag 'BWA'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("fa") > 0)     "BWA/index/$filename"         
        else null            
    }

    input:
    file(fasta_ch)

    output:
    tuple path("$fasta_ch"), path("$fasta_ch*"), emit: fasta_index

    script:
    """
    bwa index $fasta_ch
    """
}