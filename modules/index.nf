process index {
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
    singularity exec /home/tigem/s.slovin/singularity/cachedir/atacseq-0.1.6.simg bwa index $fasta_ch
    """
}