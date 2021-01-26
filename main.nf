
numberRepetitionsForProcessA = params.repsProcessA
numberFilesForProcessA = params.filesProcessA
processAWriteToDiskMb = params.processAWriteToDiskMb
processAInput = Channel.from([1] * numberRepetitionsForProcessA)

process processA {
	publishDir "${params.output}/${task.hash}", mode: 'copy'

	input:
	val x from processAInput

	output:
	val x into processAOutput
	val x into processCInput
	val x into processDInput
	file "*.txt"

	script:
	"""
	# Simulate the time the processes takes to finish
	timeToWait=\$(shuf -i ${params.processATimeRange} -n 1)
	for i in {1..${numberFilesForProcessA}};
	do echo teste > file_\${i}.txt
	sleep ${params.processATimeBetweenFileCreationInSecs}
	done;
	sleep \$timeToWait
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

