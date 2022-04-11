/* 1
 ##### Homer #####
 # Annotate peaks with homer 
*/

process annotatePeaks {
    container 'docker://gtgraham/clear-homer:v1.0'
    echo true
    label 'annotatePeaks'
    tag 'Homer'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("txt") > 0)     "IDR/homer/txt/$filename"          
        else null            
    }

    input:
    path(homer_bed)

    output:
    path("*.txt"), emit: annotatePeaks

    script:
    """
    annotatePeaks ${homer_bed} $params.fasta -gid -gtf $params.gtf > annotatePeaks_homer_names_160_IDR_peaks.txt
    """

}

