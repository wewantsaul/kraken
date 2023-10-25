process kraken {
	container 'nanozoo/bracken:2.8--dcb3e47'

	tag "filtering kraken results"

	publishDir (
	path: "${params.out_dir}/bracken_reports/",
	mode: 'copy',
	overwrite: 'true'
	)
	
	input:
	tuple val(sample), path(fastq_1), path(fastq_2)
	path(k2database)

	output:
	tuple val(sample), file("*k2report.txt")
	tuple val(sample), file("*k2output.txt")
	tuple val(sample), file("*classified.fasta")
	tuple val(sample), file("*unclassified.fasta")

	script:

	"""
	kraken2 --use-names \
	--db $k2database \
	--report ${sample}_k2report.txt \
	--report-minimizer-data \
	--classified-out ${sample}#_classified.fasta \
	--unclassified-out ${sample}#_unclassified.fasta \
	--output ${sample}_k2output.txt \
	--paired $fastq_1 $fastq_2 \
	"""
}
