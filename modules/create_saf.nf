process create_saf {
    echo true
    label 'create_saf'
    tag 'BASH'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("saf") > 0)     "IDR/saf/$filename"          
        else null            
    }

    input:
    path(homer_bed)

    output:
    path("merged_peaks_160_IDR_peaks.IDR_peaks.saf"), emit: saf

    script:
    """
    sed -i '1d' ${homer_bed}
    awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print \$4, \$1, \$2+1, \$3, "."}' ${homer_bed} > merged_peaks_160_IDR_peaks.IDR_peaks.saf
    """
}