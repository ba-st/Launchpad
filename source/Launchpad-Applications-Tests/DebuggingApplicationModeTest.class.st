"
A DebuggingApplicationModeTest is a test class for testing the behavior of DebuggingApplicationMode
"
Class {
	#name : 'DebuggingApplicationModeTest',
	#superclass : 'LaunchpadTest',
	#category : 'Launchpad-Applications-Tests',
	#package : 'Launchpad-Applications-Tests'
}

{ #category : 'tests' }
DebuggingApplicationModeTest >> testExitFailure [

	self
		runMemoryLoggerDuring: [ DebuggingApplicationMode new exitFailure ]
		assertingLogRecordsMatch: #( '[ERROR] Exit application' )
]

{ #category : 'tests' }
DebuggingApplicationModeTest >> testExitSuccess [

	self
		runMemoryLoggerDuring: [ DebuggingApplicationMode new exitSuccess ]
		assertingLogRecordsMatch: #( '[INFO] Exit application' )
]

{ #category : 'test' }
DebuggingApplicationModeTest >> testIsDebugMode [

	self assert: DebuggingApplicationMode new isDebugMode
]

{ #category : 'tests' }
DebuggingApplicationModeTest >> testValueOnErrorDo [

	DebuggingApplicationMode new value: [  ] onErrorDo: [ self fail ].

	self
		should: [ DebuggingApplicationMode new value: [ 1 / 0 ] onErrorDo: [ self fail ] ]
		raise: ZeroDivide
]
