"
An ExampleApplicationStarterCommandLineHandlerTest is a test class for testing the behavior of ExampleApplicationStarterCommandLineHandler
"
Class {
	#name : #ExampleApplicationStarterCommandLineHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'currentLogFileName'
	],
	#category : #'Launchpad-Tests'
}

{ #category : #running }
ExampleApplicationStarterCommandLineHandlerTest >> setUp [

	super setUp.
	currentLogFileName := Smalltalk logFileName
]

{ #category : #running }
ExampleApplicationStarterCommandLineHandlerTest >> tearDown [

	Smalltalk logFileName: currentLogFileName.
	ExampleApplicationStarterCommandLineHandler defaultStackDumpFile ensureDelete.
	super tearDown
]

{ #category : #tests }
ExampleApplicationStarterCommandLineHandlerTest >> testActivation [

	| arguments handler |

	arguments := CommandLineArguments withArguments: {'example' . '--seed=1' . '--add=5'}.
	handler := ExampleApplicationStarterCommandLineHandler new commandLine: arguments.
	self shouldnt: [ handler activate ] raise: Exit.
	self assert: handler seed equals: 1.
	self assert: handler add equals: 5.
	self assert: handler sum equals: 6
]

{ #category : #tests }
ExampleApplicationStarterCommandLineHandlerTest >> testActivationWithFail [

	| arguments handler |

	arguments := CommandLineArguments withArguments: {'example' . '--seed=1' . '--add=5' . '--fail'}.
	handler := ExampleApplicationStarterCommandLineHandler new commandLine: arguments.
	self should: [ handler activate ] raise: Exit.
	self deny: handler class defaultStackDumpFile exists
]

{ #category : #tests }
ExampleApplicationStarterCommandLineHandlerTest >> testActivationWithSignalError [

	| arguments handler |

	arguments := CommandLineArguments
		withArguments: {'example' . '--seed=1' . '--add=5' . '--raise-error'}.
	handler := ExampleApplicationStarterCommandLineHandler commandLine: arguments.
	self should: [ handler activate ] raise: Exit.
	self assert: handler class defaultStackDumpFile exists
]
