nextflow.enable.dsl=2

//modules
include { fastqc } from './modules/fastqc'
include { trimming } from './modules/trimming'
include { create_bed } from './modules/create_bed'
include { create_tss } from './modules/create_tss'
include { alignment } from './modules/alignment'
include { samstat } from './modules/samstat'
include { lc_extrap } from './modules/lc_extrap'
include { remove_dups } from './modules/remove_dups'
include { samstat_uniq } from './modules/samstat_uniq'
include { samstat_sf } from './modules/samstat_sf'
include { samstat_tf } from './modules/samstat_tf'
include { similarity } from './modules/similarity'
include { bamTObedpe } from './modules/bamTObedpe'
include { peak_calling } from './modules/peak_calling'
include { j_coefficient } from './modules/j_coefficient'
include { summary_plot } from './modules/summary_plot'
include { idr } from './modules/IDR'
include { ataqv } from './modules/ATAQV'
include { bigwig } from './modules/bigwig'
include { idr_peaks } from './modules/idr_peaks'
include { annotatePeaks } from './modules/annotatePeaks'
include { create_saf } from './modules/create_saf'
include { featurecounts } from './modules/featurecounts'
include { echo } from './modules/echo'

//file
reads = Channel.from( params.reads )

//workflow
workflow {

     echo(reads)
     fastqc(reads)
     trimming(reads)
     create_bed()
     create_tss()
     //alignment(trimming.out.samples_trimmed)
     //samstat(alignment.out.alignment_bam)
     //lc_extrap(samstat.out.sorted_bam)
     //remove_dups(samstat.out.sorted_bam)
     //samstat_uniq(remove_dups.out.uniq_bam)
     //input_sf = remove_dups.out.uniq_bam.join(samstat_uniq.out.sorted_uniq_bai)
     //samstat_sf(input_sf,create_bed.out.bed)
     //samstat_tf(samstat_sf.out.sf_sorted_bam)
     //similarity(samstat_tf.out.tf_sorted_bam)
     //bamTObedpe(samstat_tf.out.tf_sorted_bam)
     //input_peakcalling = bamTObedpe.out.fragment_bed.join(samstat_tf.out.tf_sorted_bam.join(samstat_tf.out.tf_sorted_flagstat))
     //peak_calling(input_peakcalling)
     //j_coefficient(peak_calling.out.narrowPeak)
     //summary_plot(peak_calling.out.narrowPeak)
     //idr(peak_calling.out.narrowPeak)
     //input_ataqv = peak_calling.out.narrowPeak.join(samstat_tf.out.tf_sorted_bam)
     //ataqv(input_ataqv,create_tss.out.tssbed)
     //input_bigwig = samstat_tf.out.tf_sorted_flagstat.join(samstat_tf.out.tf_sorted_bam)
     //bigwig(input_bigwig)
     //idr_peaks(idr.out.filtered_bed.collect())
     //annotatePeaks(idr_peaks.out.homer_bed)
     //create_saf(idr_peaks.out.homer_bed)  
     //featurecounts(create_saf.out.saf,samstat_tf.out.bam.collect())

}
