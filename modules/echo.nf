process echo {
    echo true
    label 'echo'

    input:
    tuple val(sample_id), path(reads)

    script:
    """
    echo --sample_id ${sample_id} --reads ${reads}
    """ 
}

