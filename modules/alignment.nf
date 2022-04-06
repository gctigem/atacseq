/* 3
 ##### Alignment #####
 BWA MEM alignment and filtering non primary reads
*/

process alignment {
    container 'docker://giusmar/atacseq:0.0.1'
    echo true
    label 'alignment'
    tag 'BWA'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("bam") > 0)     "alignment/mapped/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path('*.bam'), emit: alignment_bam

    script:
    """
    bwa mem -M $params.bwaindex ${reads[0]} ${reads[1]} | samtools view -b -h -F 0x0100 -o "${sample_id}_rep1_aligned_reads.bam"

    bwa mem -M $params.bwaindex ${reads[2]} ${reads[3]} | samtools view -b -h -F 0x0100 -o "${sample_id}_rep2_aligned_reads.bam"
    """
}