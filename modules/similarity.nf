process similarity {
    echo true
    label 'similarity'
    tag 'PYTHON'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf(".{npz,pdf,tab}") > 0)       "python/similarity/${sample_id}/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(tf_sorted_bam)

    // output:
    // tuple val(sample_id), val(rep), path("${sample_id}_similarity.npz"), emit: npz
    // tuple val(sample_id), val(rep), path("Heatmap_SpearmanCorr_${sample_id}.pdf"), emit: pdf
    // tuple val(sample_id), val(rep), path("SpearmanCorr_mtx_${sample_id}.tab"), emit: tab

    script:
    """
    echo ciao
    """

}