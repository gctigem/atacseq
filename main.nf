//modules
include {      fastqc         } from './modules/fastqc'
include {      trimming       } from './modules/trimming'
include {      create_bed     } from './modules/create_bed'
include {      create_tss     } from './modules/create_tss'
include {      align          } from './modules/align'
include {      index          } from './modules/index'
include {      downloadIndex  } from './modules/downloadIndex'
include {      samstat        } from './modules/samstat'
include {      lc_extrap      } from './modules/lc_extrap'
include {      remove_dups    } from './modules/remove_dups'
include {      samstat_uniq   } from './modules/samstat_uniq'
include {      samstat_sf     } from './modules/samstat_sf'
include {      samstat_tf     } from './modules/samstat_tf'
include {      similarity     } from './modules/similarity'
include {      bamTObedpe     } from './modules/bamTObedpe'
include {      peak_calling   } from './modules/peak_calling'
include {      j_coefficient  } from './modules/j_coefficient'
include {      summary_plot   } from './modules/summary_plot'
include {      idr            } from './modules/IDR'
include {      ataqv          } from './modules/ATAQV'
include {      bigwig         } from './modules/bigwig'
include {      idr_peaks      } from './modules/idr_peaks'
include {      annotatePeaks  } from './modules/annotatePeaks'
include {      create_saf     } from './modules/create_saf'
include {      featurecounts  } from './modules/featurecounts'
include {      echo           } from './modules/echo'

// check
if (params.input)                  { input_ch = file(params.input, checkIfExists: true) }                else { exit 1, 'Input samplesheet not specified!' }
if (params.genomefai)              { genomefai_ch = file(params.genomefai, checkIfExists: true) }        else { exit 1, 'Genome fai not specified!' }
if (params.blacklist)              { blacklist_ch = file(params.blacklist, checkIfExists: true) }        else { exit 1, 'Black list not specified!' }
if (params.fasta)                  { fasta_ch = file(params.fasta, checkIfExists: true) }                else { exit 1, 'Fasta not specified!' }
if (params.gtf)                    { gtf_ch = file(params.gtf, checkIfExists: true) }                    else { exit 1, 'GTF not specified!' }

//file
inputPairReads = Channel.fromPath(input_ch)
                            .splitCsv( header:false, sep:',' )
                            .map( { row -> [sample_id = row[0], rep = row[1], read = row[2..3]] } )

//workflow
workflow {

     // index
     index(fasta_ch)

     // quality
     fastqc(inputPairReads)
     trimming(inputPairReads)

     // bed and tss
     create_bed(genomefai_ch,blacklist_ch)
     create_tss(gtf_ch)

     // align
     align(index.out.fasta_index.collect(),trimming.out.fastq)

     // stats
     samstat(align.out.mapped)
     lc_extrap(samstat.out.sorted_bam)
     remove_dups(samstat.out.sorted_bam)
     samstat_uniq(remove_dups.out.uniq_bam)
     input_sf = remove_dups.out.uniq_bam.combine(samstat_uniq.out.sorted_uniq_bam_bai, by: [0,1])
     samstat_sf(input_sf,create_bed.out.regionbed)
     samstat_tf(samstat_sf.out.sf_sorted_bam)

     // info 

     input_sim = samstat_tf.out.tf_sorted_bam.groupTuple(by: [0], sort: 'hash')
               .map( { name, rep, file -> [sample_id = name, rep = rep, uno = file[0], due = file[1] ] } )

     similarity(input_sim)
     bamTObedpe(samstat_tf.out.tf_sorted_bam)
     // input_peakcalling = bamTObedpe.out.fragment_bed.join(samstat_tf.out.tf_sorted_bam.join(samstat_tf.out.tf_sorted_flagstat))
     // peak_calling(input_peakcalling)
     // j_coefficient(peak_calling.out.narrowPeak)
     // summary_plot(peak_calling.out.narrowPeak)
     // idr(peak_calling.out.narrowPeak)
     // input_ataqv = peak_calling.out.narrowPeak.join(samstat_tf.out.tf_sorted_bam)
     // ataqv(input_ataqv,create_tss.out.tssbed)
     // input_bigwig = samstat_tf.out.tf_sorted_flagstat.join(samstat_tf.out.tf_sorted_bam)
     // bigwig(input_bigwig)
     // idr_peaks(idr.out.filtered_bed.collect())
     // annotatePeaks(idr_peaks.out.homer_bed)
     // create_saf(idr_peaks.out.homer_bed)  
     // featurecounts(create_saf.out.saf,samstat_tf.out.bam.collect())

}
