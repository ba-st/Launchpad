"
An ExampleApplicationStarterCommandLineHandlerTest is a test class for testing the behavior of ExampleApplicationStarterCommandLineHandler
"
Class {
	#name : #ExampleLaunchpadCommandLineHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'currentLogFileName'
	],
	#category : #'Launchpad-Tests'
}

{ #category : #running }
ExampleLaunchpadCommandLineHandlerTest >> setUp [

	super setUp.
	currentLogFileName := Smalltalk logFileName
]

{ #category : #running }
ExampleLaunchpadCommandLineHandlerTest >> tearDown [

	Smalltalk logFileName: currentLogFileName.
	ExampleLaunchpadCommandLineHandler defaultStackDumpFile ensureDelete.
	super tearDown
]

{ #category : #tests }
ExampleLaunchpadCommandLineHandlerTest >> testActivation [

	| arguments handler |

	arguments := CommandLineArguments withArguments: {'example' . '--seed=1' . '--add=5'}.
	handler := ExampleLaunchpadCommandLineHandler new commandLine: arguments.
	self shouldnt: [ handler activate ] raise: Exit.
	self assert: handler seed equals: 1.
	self assert: handler add equals: 5.
	self assert: handler sum equals: 6
]

{ #category : #tests }
ExampleLaunchpadCommandLineHandlerTest >> testActivationWithFail [

	| arguments handler |

	arguments := CommandLineArguments withArguments: {'example' . '--seed=1' . '--add=5' . '--fail'}.
	handler := ExampleLaunchpadCommandLineHandler new commandLine: arguments.
	self should: [ handler activate ] raise: Exit.
	self deny: handler class defaultStackDumpFile exists
]

{ #category : #tests }
ExampleLaunchpadCommandLineHandlerTest >> testActivationWithSignalError [

	| arguments handler |

	arguments := CommandLineArguments
		withArguments: {'example' . '--seed=1' . '--add=5' . '--raise-error'}.
	handler := ExampleLaunchpadCommandLineHandler commandLine: arguments.
	self should: [ handler activate ] raise: Exit.
	self assert: handler class defaultStackDumpFile exists
]
