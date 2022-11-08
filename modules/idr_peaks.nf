process idr_peaks {
    echo true
    label 'idr_peaks'
    tag 'bedtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("bed") > 0)       "IDR/merge/$filename"
        else null            
    }

    input:
    path(ird_filtered_bed)

    //output:
    //path("*homer_160_IDR_peaks.bed"), emit: homer_bed

    script:
    """
    echo ciao
    """
}
