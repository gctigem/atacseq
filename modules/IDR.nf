/* 
 ##### IDR  #####
*/

process idr {
    echo true
    label 'idr'
    tag 'IDR'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("bed") > 0)       "IDR/bed_files/$filename"
        else if (filename.indexOf("png") > 0)       "IDR/png/$filename"    
        else null            
    }

    input:
    tuple val(sample_id), path(narrowPeak)

    output:
    path("*_filtered.bed"), emit: filtered_bed
    tuple val(sample_id), file("*.png")


    script:
    """
    idr --samples ${narrowPeak} --input-file-type narrowPeak --output-file ${sample_id}_IDR.bed --rank p.value --plot --use-best-multisummit-IDR
    idr.sh ${params.idrthresh} ${sample_id}_IDR.bed ${sample_id}
    """
}