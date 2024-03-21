"
A NullStackTraceDumperTest is a test class for testing the behavior of NullStackTraceDumper
"
Class {
	#name : 'NullStackTraceDumperTest',
	#superclass : 'LaunchpadTest',
	#category : 'Launchpad-Applications-Tests',
	#package : 'Launchpad-Applications-Tests'
}

{ #category : 'tests' }
NullStackTraceDumperTest >> testDumpStackTraceFor [

	self
		runMemoryLoggerDuring: [ 
			[ 1 / 0 ]
				on: ZeroDivide
				do: [ :error | 
					NullStackTraceDumper new dumpStackTraceFor: error.
					error return
					]
			]
		assertingLogRecordsMatch: #( '[WARNING] Ignoring stack trace dumping' )
]
