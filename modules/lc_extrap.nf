process lc_extrap {
    echo true
    label 'lc_extrap'
    tag 'PRESEQ'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("txt") > 0)       "preseq/${rep}/$filename"      
        else null            
    }

    input:
    tuple val(sample_id), val(rep), path(sorted_bam)

    output:
    tuple val(sample_id), val(rep), path("${sample_id}_${rep}.ccurve.txt"), emit: txt

    script:
    """
    singularity exec /home/tigem/s.slovin/singularity/cachedir/preseq-3.1.2.simg preseq lc_extrap -bam -pe ${sorted_bam[0]} -output ${sample_id}_${rep}.ccurve.txt -verbose 
    """
}
