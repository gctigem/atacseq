nextflow.enable.dsl=2

//modules
include {      index          } from './modules/index'
include {      fastqc         } from './modules/fastqc'
include {      trimming       } from './modules/trimming'
include {      create_bed     } from './modules/create_bed'
include {      create_tss     } from './modules/create_tss'
include {      align          } from './modules/align'
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
/*include {      idr            } from './modules/idr'
include {      ataqv          } from './modules/ataqv'
include {      mkarv          } from './modules/mkarv'
include {      bigwig         } from './modules/bigwig'
include {      idr_peaks      } from './modules/idr_peaks'
include {      annotatePeaks  } from './modules/annotatePeaks'
include {      create_saf     } from './modules/create_saf'
include {      featurecounts  } from './modules/featurecounts' */

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

     index(fasta_ch)
     fastqc(inputPairReads)
     trimming(inputPairReads)
     create_bed(genomefai_ch,blacklist_ch)
     create_tss(gtf_ch)
     align(index.out.fasta_index.collect(),trimming.out.fastq)
     samstat(align.out.mapped)
     lc_extrap(samstat.out.sorted_bam)
     remove_dups(samstat.out.sorted_bam)
     samstat_uniq(remove_dups.out.uniq_bam)
     input_sf = remove_dups.out.uniq_bam.combine(samstat_uniq.out.sorted_uniq_bam_bai, by: [0,1])
     samstat_sf(input_sf,create_bed.out.regionbed)
     samstat_tf(samstat_sf.out.sf_sorted_bam)
     input_sim = samstat_tf.out.tf_sorted_bam.groupTuple(by: [0], sort: 'hash')
               .map( { name, rep, file -> [sample_id = name, rep = rep, uno = file[0], due = file[1] ] } )
     similarity(input_sim)
     bamTObedpe(samstat_tf.out.tf_sorted_bam)
     input_pc = bamTObedpe.out.fragment_bed.combine(
          samstat_tf.out.tf_sorted_bam.combine(
               samstat_tf.out.tf_sorted_flagstat, by: [0,1]),
                                                  by: [0,1])
     peak_calling(input_pc)
     input_jc = peak_calling.out.narrowPeak.groupTuple(by :[0], sort: 'true')
     j_coefficient(input_jc)
     summary_plot(input_jc)
     /*idr(input_jc)
     input_av = peak_calling.out.narrowPeak.combine(samstat_tf.out.tf_sorted_bam, by: [0,1])
     ataqv(input_av,create_tss.out.tssbed)
     mkarv(ataqv.out.json.groupTuple(by: [0], sort: 'true'))
     input_bw = samstat_tf.out.tf_sorted_bam.combine(samstat_tf.out.tf_sorted_flagstat, by: [0,1])
     bigwig(input_bw)
     idr_peaks(idr.out.filtered_bed.collect{ it[1] })
     annotatePeaks(idr_peaks.out.homer_bed,fasta_ch,gtf_ch)
     create_saf(idr_peaks.out.homer_bed)  
     featurecounts(create_saf.out.saf,samstat_tf.out.tf_sorted_bam.collect{ it[2][[0]]}) */

}
