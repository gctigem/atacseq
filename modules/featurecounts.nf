/* 
 ##### featurecounts #####
 # Create SAF file for featurecounts
*/

process featurecounts {
    echo true
    label 'featurecounts'
    tag 'featurecounts'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("txt") > 0)     "featurecounts/$filename"          
        else null            
    }

    input:
    path(saf)
    path(tf_sorted_bam)

    output:
    path("*.txt"), emit: count

    script:
    """
    featureCounts -F SAF -O --fracOverlap 0.2 -p -a ${saf} -o IDR_peaks.featureCounts.txt ${tf_sorted_bam}
    """
}
