Class {
	#name : #LaunchpadTest,
	#superclass : #TestCase,
	#instVars : [
		'runningApplication',
		'loggingAsserter'
	],
	#category : #'Launchpad-SUnit'
}

{ #category : #testing }
LaunchpadTest class >> isAbstract [

	^ self = LaunchpadTest
]

{ #category : #private }
LaunchpadTest >> assertLogRecordsMatch: expectedLogEntries [

	loggingAsserter assertLogRecordsMatch: expectedLogEntries 
]

{ #category : #private }
LaunchpadTest >> assertThereAreNoLogRecords [

	self assertLogRecordsMatch: #(  )
]

{ #category : #running }
LaunchpadTest >> runCase [

	self shouldnt: [ super runCase ] raise: Exit
]

{ #category : #private }
LaunchpadTest >> runMemoryLoggerDuring: aBlock [

	loggingAsserter runMemoryLoggerDuring: aBlock
]

{ #category : #private }
LaunchpadTest >> runMemoryLoggerDuring: aBlock assertingLogRecordsMatch: expectedLogEntries [

	self
		runMemoryLoggerDuring: aBlock;
		assertLogRecordsMatch: expectedLogEntries
]

{ #category : #running }
LaunchpadTest >> setUp [

	super setUp.
	loggingAsserter := LoggingAsserter on: self
]

{ #category : #private }
LaunchpadTest >> start: aLaunchpadApplication withAll: arguments [

	self runMemoryLoggerDuring: [ 
		String streamContents: [ :output | 
			| rootCommand commandLine context |

			rootCommand := LaunchpadRootCommand new.
			commandLine := CommandLineArguments withArguments: { 
					               'launchpad'.
					               'start'.
					               '--debug-mode'.
					               aLaunchpadApplication commandName } , arguments.
			context := LaunchpadCommandLineProcessingContext handling: commandLine writingTo: output.
			self assert: ( rootCommand canHandle: ( context nextCommandLineArgumentIfNone: [ self fail ] ) ).
			rootCommand evaluateWithin: context.
			runningApplication := LaunchpadApplication currentlyRunning
			]
		]
]

{ #category : #running }
LaunchpadTest >> tearDown [

	loggingAsserter stopLoggers.
	runningApplication ifNotNil: [:application | application stop].
	LaunchpadApplication resetCurrentlyRunning.
	super tearDown
]
