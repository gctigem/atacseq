/* 
 ##### Create TSS file  #####
*/

process create_tss {
    echo true
    label 'create_tss'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("bed") > 0)       "samtools/gtf2tss/$filename"
        else null            
    }
    
    output:
    path("*.tss.bed"), emit: tssbed
    
    script:
    """
    gtf2bed $params.gtf > genes.bed
    cat genes.bed | awk -v FS='\t' -v OFS='\t' '{ if(\$6=="+") \$3=\$2+1; else \$2=\$3-1; print \$1, \$2, \$3, \$4, \$5, \$6;}' > genes.tss.bed
    """    
}
