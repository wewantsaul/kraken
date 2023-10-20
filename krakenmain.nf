nextflow.enable.dsl=2

include {fastp} from './modules/fastp.nf'
include {bwamem} from './modules/bwamem.nf'
include {bamstats} from './modules/bamstats.nf'
include {samfilter} from './modules/samfilter.nf'
include {samfastq} from './modules/samfastq.nf'
include {kraken} from './modules/kraken.nf'



workflow {

	Channel
		.fromFilePairs("$PWD/${params.reads}/*{,.trimmed}_{R1,R2,1,2}{,_001}.{fastq,fq}{,.gz}", flat:true)
		.ifEmpty{error "Cannot find any reads matching: ${params.reads}"}
		.set{ch_reads}

	index_folder = file( 'human_index/GRCh38_latest_genomic.fna.*' )
	
	main:
		fastp(ch_reads)
		bwamem(fastp.out.trimmed, index_folder)
		bamstats(bwamem.out.aligned_bam)
		samfilter(bwamem.out.aligned_bam)
		samfastq(samfilter.out.filtered_bam)
		kraken(samfastq.out.filtered_fastq, params.k2database)
		
}	

