process lc_extrap {
    container 'docker://clinicalgenomics/preseq:3.1.2'
    echo true
    label 'lc_extrap'
    tag 'PRESEQ'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("txt") > 0)       "preseq/${rep}/$filename"      
        else null            
    }

    input:
    tuple val(sample_id), value(rep), path(bam)

    output:
    tuple val(sample_id), value(rep), path("${sample_id}_${rep}.ccurve.txt"), emit: txt

    script:
    """
    preseq lc_extrap -output ${sample_id}_${rep}.ccurve.txt -verbose -bam -pe ${bam}
    """
}
