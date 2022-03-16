process echo {
    echo true
    label 'echo'

    input:
    tuple val(sample_id), path(bed), path(bam), path(flagstat)

    script:
    """
    echo --sample_id $sample_id 
    echo --bed $bed
    echo --bam $bam
    echo --flagstat $flagstat
    """ 
}

