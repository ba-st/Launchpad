Class {
	#name : #LaunchpadTest,
	#superclass : #TestCase,
	#instVars : [
		'memoryLogger',
		'runningApplication'
	],
	#category : #'Launchpad-SUnit'
}

{ #category : #testing }
LaunchpadTest class >> isAbstract [

	^ self = LaunchpadTest
]

{ #category : #private }
LaunchpadTest >> assertLogRecordsMatch: expectedLogEntries [

	memoryLogger recordings with: expectedLogEntries do: [ :record :expectedLogEntry | 
		self assert: ( record printString includesSubstring: expectedLogEntry ) ]
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

	memoryLogger runDuring: aBlock
]

{ #category : #running }
LaunchpadTest >> setUp [

	super setUp.
	memoryLogger := MemoryLogger new
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

{ #category : #private }
LaunchpadTest >> stopLoggers [

	StandardStreamLogger onStandardOutput stop.
	StandardStreamLogger onStandardError stop.
	StandardErrorStructuredLogger onStandardOutput stop.
	StandardErrorStructuredLogger onStandardError stop
]

{ #category : #running }
LaunchpadTest >> tearDown [

	memoryLogger reset.
	self stopLoggers.
	runningApplication ifNotNil: #stop.
	super tearDown
]
