process mkarv {
    container 'docker://umichbfxcore/ataqv:0.1.0'
    echo true
    label 'mkarv'
    tag 'ATAQV'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("html") > 0)       "ATAQV/html/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(json)
    output:
    tuple val(sample_id), val(rep), path("${sample_id}_qc.html"), emit: html


    script:
    """
    mkarv ${sample_id}_qc.html ${json}
    """
}
