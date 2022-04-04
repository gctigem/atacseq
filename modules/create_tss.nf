/* 
 ##### Create Bed file  #####
 Prepare genome intervals for filtering
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
    path file("*.tss.bed"), emit: tssbed
    
    script:
    """
    gtf2bed $params.gtf > ${params.gtf.baseName}.bed
    cat ${params.gtf.baseName}.bed | awk -v FS='\t' -v OFS='\t' '{ if(\$6=="+") \$3=\$2+1; else \$2=\$3-1; print \$1, \$2, \$3, \$4, \$5, \$6;}' > ${params.gtf.baseName}.tss.bed
    """    
}
