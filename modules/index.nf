process index {
    echo true
    label 'index'
    tag 'BWA'
    container 'docker://giusmar/atacseq:0.1.6'
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