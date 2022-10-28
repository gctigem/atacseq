process downloadIndex {
    echo true
    label 'index'
    tag 'BWA'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("fa") > 0)     "BWA/index/$filename"         
        else null            
    }

    input:
    file(index)

    output:
    tuple path("$fasta_ch"), path("$fasta_ch*"), emit: fasta_index
}