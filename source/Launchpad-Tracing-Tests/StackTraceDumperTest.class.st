Class {
	#name : #StackTraceDumperTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Tracing-Tests'
}

{ #category : #testing }
StackTraceDumperTest class >> isAbstract [

	^ self = StackTraceDumperTest
]

{ #category : #tests }
StackTraceDumperTest >> generateErrorDumpingStackTraceWith: dumper [

	<ignoreForCoverage>
	[ AssertionFailed signal ]
		on: AssertionFailed
		do: [ :error | dumper dumpStackTraceFor: error ]
]
