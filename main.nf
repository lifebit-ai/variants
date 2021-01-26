
numberRepetitionsForProcessA = params.repsProcessA
numberFilesForProcessA = params.filesProcessA
processAWriteToDiskMb = params.processAWriteToDiskMb
processAInput = Channel.from([1] * numberRepetitionsForProcessA)
processAS3InputFiles = Channel.fromPath("${params.s3Location}/*${params.fileSuffix}").take( numberRepetitionsForProcessA )

process processA {
	publishDir "${params.output}/MultiQC", mode: 'copy'
  	tag "$s3_file"

	input:
	val x from processAInput
	file(s3_file) from  processAS3InputFiles

	output:
	val x into processAOutput
	val x into processCInput
	val x into processDInput
	file("multiqc_report.html")

	script:
	"""
	mv $s3_file multiqc_report.html 
	"""
}

process processB {

	input:
	val x from processAOutput


	"""
    # Simulate the time the processes takes to finish
    timeToWait=\$(shuf -i ${params.processBTimeRange} -n 1)
    sleep \$timeToWait
	dd if=/dev/urandom of=newfile bs=1M count=${params.processBWriteToDiskMb}	
	"""
}

process processC {

	input: 
	val x from processCInput

	"""
    # Simulate the time the processes takes to finish
    timeToWait=\$(shuf -i ${params.processCTimeRange} -n 1)
    sleep \$timeToWait
	"""
}


process processD {

	input: 
	val x from processDInput

	"""
    # Simulate the time the processes takes to finish
    timeToWait=\$(shuf -i ${params.processDTimeRange} -n 1)
    sleep \$timeToWait
	"""
}

