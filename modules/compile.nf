process compile {

	tag "compiling kraken reports"

	publishDir (
	path: "${params.out_dir}/kraken_reports/",
	mode: 'copy',
	overwrite: 'true'
	)
	
	input:
	tuple val(sample), path(k2report)

	output:
	file("*report.txt")

	script:
	"""
	cp $k2report ${sample}_report.txt
	"""
}
