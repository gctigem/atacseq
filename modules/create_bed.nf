process create_bed {
    echo true
    label 'create_bed'
    tag 'SAMTOOLS'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("chr") > 0)           "samtools/bed_files/$filename"
        else if (filename.indexOf("txt") > 0)           "samtools/bed_files/$filename"
        else if (filename.indexOf("sizes") > 0)         "samtools/bed_files/$filename"
        else null            
    }

    input:
    path(genomefai_ch)
    path(blacklist_ch)

    output:
    path("chr.genome.fa.include_regions.bed"), emit: regionbed
    path("*.txt"), emit: txt
    path("*.sizes"), emit: sizes

    script:
    """
    get_autosomes.py ${genomefai_ch} genome.fa.autosomes.txt
    cut -f 1,2 ${genomefai_ch} > genome.fa.fai.sizes
    sortBed -i ${blacklist_ch} -g genome.fa.fai.sizes | complementBed -i stdin -g genome.fa.fai.sizes > genome.fa.include_regions.bed
    cat genome.fa.include_regions.bed | grep "chr" > chr.genome.fa.include_regions.bed
    """

}