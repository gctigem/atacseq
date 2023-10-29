process idr_peaks {
    echo true
    label 'idr_peaks'
    tag 'bedtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("homer") > 0)       "IDR/merged_peaks/$filename"
        else null            
    }

    input:
    path(ird_filtered_bed)

    output:
    path("merged_peaks_homer_160_IDR_peaks.bed"), emit: homer_bed

    script:
    """
    cat ${ird_filtered_bed} | awk -v OFS="\t" '{$8="1" ; print ;}' | sort -k1,1 -k2,2n | bedtools merge -i stdin > merged_peaks_160_IDR_peaks.bed
    awk -v OFS='\t' 'BEGIN{FS=OFS="\t";print "Chr\tStart\tEnd\tPeakID\tignor\tStrand"} {print \$1, \$2, \$3,"TF_peak_"NR ,"Shaked", "."}' merged_peaks_160_IDR_peaks.bed > merged_peaks_homer_160_IDR_peaks.bed
    """
}
