process bamTObedpe {
    echo true
    label 'bamTObedpe'
    tag 'SAMTOOLS'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("sorted.bam") > 0)       "samtools/bamTObedpe/${rep}/name_sorted/$filename"
        else if (filename.indexOf("fragments.bed") > 0)       "samtools/bamTObedpe/${rep}/fragment_bed/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(bamF)

    output:
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_name_sorted.bam"), emit: name_sorted_bam
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_fragments.bed"), emit: fragment_bed

    script:
    """
    samtools sort -n -o ${sample_id}_${rep}_name_sorted.bam ${bamF[0]}
    bedtools bamtobed -i ${sample_id}_${rep}_name_sorted.bam -bedpe | \\
     awk -v OFS="\t" '{if(\$9=="+"){print \$1,\$2+4,\$6+4}else if(\$9=="-"){print \$1,\$2-5,\$6-5}}' > ${sample_id}_${rep}_fragments.bed
    """
}