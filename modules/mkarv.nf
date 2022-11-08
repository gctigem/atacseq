process mkarv {
    echo true
    label 'mkarv'
    tag 'ATAQV'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("qc") > 0)       "ATAQV/qc/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(json)
    
    output:
    tuple val(sample_id), val(rep), path("${sample_id}_qc"), emit: qc


    script:
    """
    mkarv ${sample_id}_qc ${json} -t /ataqv/src/web
    """
}
