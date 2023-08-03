process annotatePeaks {
    echo true
    label 'annotatePeaks'
    tag 'HOMER'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("txt") > 0)     "IDR/annotate_peaks/$filename"          
        else null            
    }

    input:
    path(homer_bed)
    path(fasta)
    path(gtf)

    output:
    path("annotatePeaks_homer_names_160_IDR_peaks.txt"), emit: annotatePeaks

    script:
    """
    perl annotatePeaks.pl ${homer_bed} ${fasta} -gid -gtf ${gtf} > annotatePeaks_homer_names_160_IDR_peaks.txt
    """

}

