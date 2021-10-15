"
A NullStackTraceDumperTest is a test class for testing the behavior of NullStackTraceDumper
"
Class {
	#name : #NullStackTraceDumperTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Applications-Tests'
}

{ #category : #test }
NullStackTraceDumperTest >> testDumpStackTraceFor [

	| logger |

	logger := MemoryLogger new runDuring: [ 
		          [ 1 / 0 ] on: ZeroDivide
			          do: [ :error | 
				          NullStackTraceDumper new dumpStackTraceFor: error.
				          error return
				          ]
		          ].

	self withTheOnlyOneIn: logger recordings do: [ :recording | 
		self assert: ( recording printString endsWith: '[WARNING] Ignoring stack trace dumping' ) ]
]
