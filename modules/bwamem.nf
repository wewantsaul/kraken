process bwamem {
	container 'biocontainers/bwa:v0.7.17_cv1'

	tag "aligning $sample to reference"

	publishDir (
	path: "${params.out_dir}/$sample/02_alignment/",
	mode: 'copy',
	overwrite: 'true'
	)
	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)
	path index_folder
	
	output:
	tuple val(sample), path("*aligned.bam"), emit: aligned_bam

	script:

	def idxbase = index_folder[0].baseName
	
	"""
	bwa mem -t 4 \
	"${idxbase}" \
	$fastq_1 $fastq_2 > ${sample}_aligned.bam
	"""
}
