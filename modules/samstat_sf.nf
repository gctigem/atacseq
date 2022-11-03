process samstat_sf {
    echo true
    label 'samstat_sf'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("sorted.bam") > 0)       "samstat/second_filtering/${rep}/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(sorted_uniq_bam), path(sorted_uniq_bai)
    path(bed)

    output:
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}_secondary_filtering.sorted.bam"), emit: sf_sorted_bam

    script:
    """
    samtools view -F 4 -F 8 -F 256 -F 1024 -F 2048 -f2 -q 1 -L ${bed} -b ${sorted_uniq_bam} | bamtools filter -script $baseDir/assets/$params.bamtools_filter | samtools view -h | awk 'substr(\$0,1,1)=="@" || (\$9>= 38 && \$9<=2000) || (\$9<=-38 && \$9>=-2000)' | samtools view -b > ${sample_id}_${rep}_secondary_filtering.sorted.bam
    """

}
