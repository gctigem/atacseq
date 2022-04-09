/* 
 ##### Convert BAM to BEDPE  #####
*/

process bamTObedpe {
    container 'docker://giusmar/atacseq:0.0.6'
    echo true
    label 'bamTObedpe'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "samtools/bamTObedpe/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "samtools/bamTObedpe/rep2/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(tf_sorted_bam)

    output:
    tuple val(sample_id), path("*.name.sorted.bam"), emit: name_sorted_bam
    tuple val(sample_id), path("*fragments.bed"), emit: fragment_bed

    script:
    """
    samtools sort -n -o ${sample_id}_rep1.name.sorted.bam ${tf_sorted_bam[0]}
    bedtools bamtobed -i ${sample_id}_rep1.name.sorted.bam -bedpe | awk -v OFS="\t" '{if(\$9=="+"){print \$1,\$2+4,\$6+4}else if(\$9=="-"){print \$1,\$2-5,\$6-5}}' > ${sample_id}_rep1_fragments.bed

    samtools sort -n -o ${sample_id}_rep2.name.sorted.bam ${tf_sorted_bam[1]}
    bedtools bamtobed -i ${sample_id}_rep2.name.sorted.bam -bedpe | awk -v OFS="\t" '{if(\$9=="+"){print \$1,\$2+4,\$6+4}else if(\$9=="-"){print \$1,\$2-5,\$6-5}}' > ${sample_id}_rep2_fragments.bed
    """
}