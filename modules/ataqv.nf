process ataqv {
    container 'docker://giusmar/atacseq:0.1.5'
    echo true
    label 'ataqv'
    tag 'ATAQV'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "ATAQV/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "ATAQV/rep2/$filename"
        else if (filename.indexOf("html") > 0)       "ATAQV/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(narrowPeak), path(tf_sorted_bam)
    path(tssbed)

    // output:
    // tuple val(sample_id), path("*.json"), emit: json
    // tuple val(sample_id), path("*.out"), emit: out
    // tuple val(sample_id), path("*.html"), emit: html


    script:
    """
    ataqv --peak-file ${narrowPeak} --tss-file ${tssbed} --metrics-file ${sample_id}_${rep}.ataqv.json --name ${sample_id}_${rep} --ignore-read-groups --autosomal-reference-file $baseDir/assets/$params.autosomesbed MT ${tf_sorted_bam[0]} > ${sample_id}_${rep}.ataqv.out
    """
}
