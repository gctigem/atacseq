/* 
 ##### bigwig  #####
 Create normalized bigwig files
*/

process bigwig {
    container 'docker://giusmar/atacseq:0.0.12'
    echo true
    label 'bigwig'
    tag 'bedtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "bedGraph/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "bedGraph/rep2/$filename"
        else if (filename.indexOf("txt") > 0)       "bedGraph/txt/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(tf_sorted_flagstat), path(tf_sorted_bam)

    output:
    tuple val(sample_id), path("*.bedGraph"), emit: bedGraph
    tuple val(sample_id), path("*.bigWig"), emit: bigWig
    tuple val(sample_id), path("*.txt"), emit: txt

    script:
    """
    echo `grep 'mapped (' ${tf_sorted_flagstat[0]} | awk '{print 1000000/\$1}'` > ${sample_id}_rep1.scale_factor.txt
    bedtools genomecov -ibam ${tf_sorted_bam[0]} -bg -scale ${sample_id}_rep1.scale_factor.txt -pc | sort -k1,1 -k2,2n > ${sample_id}_rep1.bedGraph
    bedGraphToBigWig ${sample_id}_rep1.bedGraph $baseDir/assets/$params.sizes ${sample_id}_rep1.bigWig

    echo `grep 'mapped (' ${tf_sorted_flagstat[1]} | awk '{print 1000000/\$1}'` > ${sample_id}_rep2.scale_factor.txt
    bedtools genomecov -ibam ${tf_sorted_bam[1]} -bg -scale ${sample_id}_rep2.scale_factor.txt -pc | sort -k1,1 -k2,2n > ${sample_id}_rep2.bedGraph
    bedGraphToBigWig ${sample_id}_rep2.bedGraph $baseDir/assets/$params.sizes ${sample_id}_rep2.bigWig
    """
}
