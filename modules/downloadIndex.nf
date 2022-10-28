process downloadIndex {
    echo true
    label 'index'
    tag 'GSUTIL'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("fa") > 0)     "BWA/index/$filename"         
        else null            
    }

    input:
    path(index_ch)

    output:
    tuple path("$fasta_ch"), path("$fasta_ch*"), emit: fasta_index

    script:
    """
    mv bwa_*/* .
    """
}