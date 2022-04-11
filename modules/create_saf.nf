/* 1
 ##### SAF #####
 # Create SAF file for featurecounts
*/

process create_saf {
    container 'docker://giusmar/atacseq:0.0.12'
    echo true
    label 'create_saf'
    tag 'bash'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("saf") > 0)     "IDR/saf/$filename"          
        else null            
    }

    input:
    path(homer_bed)

    output:
    path("*.saf"), emit: saf

    script:
    """
    sed -i '1d' ${homer_bed}
    awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print \$4, \$1, \$2+1, \$3, "."}' ${homer_bed} > merged_peaks_160_IDR_peaks.IDR_peaks.saf
    """
}