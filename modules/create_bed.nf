/* 
 ##### Create Bed file  #####
 Prepare genome intervals for filtering
*/

process create_bed {
    echo true
    label 'create_bed'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("chr") > 0)       "samtools/bed_files/$filename"
        else if (filename.indexOf("txt") > 0)       "samtools/bed_files/$filename"
        else if (filename.indexOf("sizes") > 0)       "samtools/bed_files/$filename"
        else null            
    }

    output:
    path("chr.genome.fa.include_regions.bed"), emit: bed
    path("*.txt")
    path("*.sizes")

    script:
    """
    get_autosomes.py $params.genomefai genome.fa.autosomes.txt
    cut -f 1,2 $params.genomefai > genome.fa.fai.sizes
    sortBed -i $params.blacklist -g genome.fa.fai.sizes | complementBed -i stdin -g genome.fa.fai.sizes > genome.fa.include_regions.bed
    cat genome.fa.include_regions.bed | grep "chr" > chr.genome.fa.include_regions.bed
    """

}