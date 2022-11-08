process bigwig {
    echo true
    label 'bigwig'
    tag 'BEDTOOLS'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("bedGraph") > 0)       "bedGraph/${rep}/bedGraph/$filename"
        else if (filename.indexOf("bigWig") > 0)       "bedGraph/${rep}/bigWig/$filename"
        else if (filename.indexOf("scale_factor") > 0)       "bedGraph/${rep}/txt/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(tf_sorted_bam), path(tf_sorted_flagstat)

    output:
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}.bedGraph"), emit: bedGraph
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}.bigWig"), emit: bigWig
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}.scale_factor.txt"), emit: txt

    script:
    """
    echo `grep 'mapped (' ${tf_sorted_flagstat[0]} | awk '{print 1000000/\$1}'` > ${sample_id}_${rep}.scale_factor.txt
    bedtools genomecov -ibam ${tf_sorted_bam[0]} -bg -scale ${sample_id}_${rep}.scale_factor.txt -pc | sort -k1,1 -k2,2n > ${sample_id}_${rep}.bedGraph
    bedGraphToBigWig ${sample_id}_${rep}.bedGraph $baseDir/assets/$params.sizes ${sample_id}_${rep}.bigWig
    """
}
