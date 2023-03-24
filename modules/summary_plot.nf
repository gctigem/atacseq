process summary_plot {
    echo true
    label 'summary_plot'
    tag 'R'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("txt") > 0)       "R/QC/${rep[0]}/txt/$filename"
        else if (filename.indexOf("pdf") > 0)       "R/QC/${rep[1]}/pdf/$filename"
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(narrowPeak)

    output:
    tuple val(sample_id), val(rep), path("*.txt"), emit: summary_txt
    tuple val(sample_id), val(rep), path("*.pdf"), emit: summary_pdf

    script:
    """
    singularity exec /home/tigem/s.slovin/singularity/cachedir/atacseq-0.1.6.simg Rscript /home/tigem/s.slovin/r_scripts/plot_macs_qc.r -i ${narrowPeak[0]} -s ${sample_id}_${rep[0]}_peaks -p macs_peak.${sample_id}_${rep[0]}
    singularity exec /home/tigem/s.slovin/singularity/cachedir/atacseq-0.1.6.simg Rscript /home/tigem/s.slovin/r_scripts/plot_macs_qc.r -i ${narrowPeak[1]} -s ${sample_id}_${rep[1]}_peaks -p macs_peak.${sample_id}_${rep[1]}
    """
}