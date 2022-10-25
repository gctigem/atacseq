process index {
    echo true
    label 'index'
    tag 'BWA'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("fa") > 0)     "BWA/$params.bwa_nCoV_fa/$filename"         
        else null            
    }

    input:
    file(fasta)

    output:
    tuple path("$fasta"), path("$fasta*"), emit: fasta_index

    script:
    """
    bwa index $fasta
    """
}