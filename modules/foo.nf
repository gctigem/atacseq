process foo {
    debug true
    tag 'foo'
    label 'foo'
    publishDir "$params.outdir" , mode: 'copy'

    input:
    path(indexed)

    script:
    """
    head genome.fa
    """
}