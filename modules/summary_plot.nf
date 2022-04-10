/* 
 ##### Summary plot for peak calling ##  #####
*/

process summary_plot {
    container 'docker://giusmar/atacseq:0.0.8'
    echo true
    label 'summary_plot'
    tag 'R'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("rep1") > 0)       "R/QC/rep1/$filename"
        else if (filename.indexOf("rep2") > 0)       "R/QC/rep2/$filename"
        else null            
    }

    input:
    tuple val(sample_id), path(narrowPeak)

    output:
    tuple val(sample_id), path("*.txt"), emit: summary_txt
    tuple val(sample_id), path("*.pdf"), emit: summary_pdf

    script:
    """
    plot_macs_qc.r -i ${narrowPeak[0]} -s ${sample_id}_rep1_peaks -p macs_peak.${sample_id}_rep1
    plot_macs_qc.r -i ${narrowPeak[1]} -s ${sample_id}_rep2_peaks -p macs_peak.${sample_id}_rep2
    """
}