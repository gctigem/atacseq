process align {
    echo true
    label 'alignment'
    tag 'BWA'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("bam") > 0)     "alignment/mapped/$filename"
        else null            
    }

    input:
    path(fasta_index)
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path('*.bam'), emit: alignment_bam

    script:
    """
    bwa mem -M ${fasta_index[0]} ${reads[0]} ${reads[1]} | samtools view -b -h -F 0x0100 -o "${sample_id}_rep1_aligned_reads.bam"    
    """
}
