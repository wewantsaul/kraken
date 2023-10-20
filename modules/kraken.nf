process kraken {
//	container 'staphb/kraken2:2.1.2-no-db'
	container 'staphb/kraken2:2.1.3'

	tag "identifying sequences"

	publishDir (
	path: "${params.out_dir}/$sample/04_kraken/",
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
