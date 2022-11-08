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
    tuple val(sample_id), val(rep), path(ird_filtered_bed)

    output:
    path("*homer_160_IDR_peaks.bed"), emit: homer_bed

    script:
    """
    cat `ls .` | sort -k1,1 -k2,2n > merged_peaks_160_IDR_peaks.bed
    awk -v OFS='\t' 'BEGIN{FS=OFS="\t";print "Chr\tStart\tEnd\tPeakID\tignor\tStrand"} {print \$1, \$2, \$3,"TF_peak_"NR ,"Shaked", "."}' merged_peaks_160_IDR_peaks.bed > merged_peaks_homer_160_IDR_peaks.bed
    """
}
