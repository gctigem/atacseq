/* 
 ##### ATAQV  #####
*/

process ataqv {
    container 'docker://giusmar/atacseq:0.0.10'
    echo true
    label 'ataqv'
    tag 'ataqv'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "ATAQV/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "ATAQV/rep2/$filename"
        else if (filename.indexOf("html") > 0)       "ATAQV/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(narrowPeak), path(tf_sorted_bam)
    path(tssbed)

    output:
    tuple val(sample_id), path("*.json"), emit: json
    tuple val(sample_id), path("*.out"), emit: out
    tuple val(sample_id), path("*.html"), emit: html


    script:
    """
    samtools index ${tf_sorted_bam[0]}
    ataqv --peak-file ${narrowPeak[0]} --tss-file ${tssbed} --metrics-file ${sample_id}_rep1.ataqv.json --name ${sample_id}_rep1  --ignore-read-groups --autosomal-reference-file $baseDir/assets/$params.autosomesbed MT ${tf_sorted_bam[0]} > ${sample_id}_rep1.ataqv.out
    
    samtools index ${tf_sorted_bam[1]}
    ataqv --peak-file ${narrowPeak[1]} --tss-file ${tssbed} --metrics-file ${sample_id}_rep2.ataqv.json --name ${sample_id}_rep2  --ignore-read-groups --autosomal-reference-file $baseDir/assets/$params.autosomesbed MT ${tf_sorted_bam[1]} > ${sample_id}_rep2.ataqv.out

    mkarv ${sample_id}_qc.html ${sample_id}_rep1.ataqv.json ${sample_id}_rep2.ataqv.json
    """
}
