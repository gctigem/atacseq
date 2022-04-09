/* 
 ##### Samstat second filtering #####
*/

process samstat_sf {
    container 'docker://giusmar/atacseq:0.0.6'
    echo true
    label 'samstat_sf'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "samstat/second_filtering/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "samstat/second_filtering/rep2/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(uniq_bam), path(sorted_uniq_bai)
    path(bed)

    output:
    tuple val(sample_id), path("*.bam"), emit: sf_sorted_bam


    script:
    """
    samtools view -F 4 -F 8 -F 256 -F 1024 -F 2048 -f2 -q 1 -L ${bed} -b ${uniq_bam[0]} | bamtools filter -script $baseDir/assets/$params.bamtools_filter | samtools view -h | awk 'substr(\$0,1,1)=="@" || (\$9>= 38 && \$9<=2000) || (\$9<=-38 && \$9>=-2000)' | samtools view -b > ${sample_id}_rep1.secondary_filtering.sorted.bam
    
    rm ${uniq_bam[0]}
    
    samtools view -F 4 -F 8 -F 256 -F 1024 -F 2048 -f2 -q 1 -L ${bed} -b ${uniq_bam[1]} | bamtools filter -script $baseDir/assets/$params.bamtools_filter | samtools view -h | awk 'substr(\$0,1,1)=="@" || (\$9>= 38 && \$9<=2000) || (\$9<=-38 && \$9>=-2000)' | samtools view -b > ${sample_id}_rep2.secondary_filtering.sorted.bam
    
    rm ${uniq_bam[1]}
    """

}
