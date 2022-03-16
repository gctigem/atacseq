/* 
 ##### Similarity #####
 Similarity among biological replicates
*/

process similarity {
    echo true
    label 'similarity'
    tag 'Python'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep") > 0)       "python/similarity/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(tf_sorted_bam)

    output:
    path("*.npz"), emit: npz
    path("*.pdf"), emit: pdf
    path("*.tab"), emit: tab

    script:
    """
    samtools index ${tf_sorted_bam[0]}
    samtools index ${tf_sorted_bam[1]}
    multiBamSummary bins --bamfiles ${tf_sorted_bam} -o ${sample_id}_rep_similarity.npz

    plotCorrelation -in ${sample_id}_rep_similarity.npz --corMethod spearman --labels ${sample_id}_rep1 ${sample_id}_rep2 --skipZeros --whatToPlot heatmap --plotNumbers -o heatmap_SpearmanCorr_rep_${sample_id}.pdf --outFileCorMatrix SpearmanCorr_mtx_rep_${sample_id}.tab
    """

}