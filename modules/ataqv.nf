process ataqv {
    container 'docker://giusmar/atacseq:0.1.5'
    echo true
    label 'ataqv'
    tag 'ATAQV'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("json") > 0)       "ATAQV/${rep}/json/$filename"
        else if (filename.indexOf("out") > 0)       "ATAQV/${rep}/out/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(narrowPeak), path(tf_sorted_bam)
    path(tssbed)

    output:
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}.ataqv.json"), emit: json
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}.ataqv.out"), emit: out


    script:
    """
    ataqv --peak-file ${narrowPeak} --tss-file ${tssbed} --metrics-file ${sample_id}_${rep}.ataqv.json --name ${sample_id}_${rep} --ignore-read-groups --autosomal-reference-file $baseDir/assets/$params.autosomesbed MT ${tf_sorted_bam[0]} > ${sample_id}_${rep}.ataqv.out
    """
}
