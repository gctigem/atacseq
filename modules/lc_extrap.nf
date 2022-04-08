/* 4
 ##### Library complexity #####
*/

process lc_extrap {
    container 'docker://giusmar/atacseq:0.0.4'
    echo true
    label 'lc_extrap'
    tag 'Preseq'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("txt") > 0)       "preseq/$filename"      
        else null            
    }

    input:
    tuple val(sample_id), path(bam)

    output:
    path("*.txt"), emit: txt

    script:
    """
    preseq-3.1.2/preseq lc_extrap -output ${sample_id}_rep1.ccurve.txt -verbose -bam -pe ${bam[0]}
    preseq-3.1.2/preseq lc_extrap -output ${sample_id}_rep2.ccurve.txt -verbose -bam -pe ${bam[1]}
    """
}
