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

	[ 1 / 0 ] on: Error
		do: [ :error | dumper dumpStackTraceFor: error ]
]
