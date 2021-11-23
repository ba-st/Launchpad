"
A DebuggingApplicationModeTest is a test class for testing the behavior of DebuggingApplicationMode
"
Class {
	#name : #DebuggingApplicationModeTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Applications-Tests'
}

{ #category : #tests }
DebuggingApplicationModeTest >> testExitFailure [

	self
		shouldnt: [ 
			| logger |

			logger := MemoryLogger new runDuring: [ DebuggingApplicationMode new exitFailure ].
			self withTheOnlyOneIn: logger recordings
				do: [ :recording | self assert: ( recording printString endsWith: '[ERROR] Exit application' ) ]
			]
		raise: Exit
]

{ #category : #tests }
DebuggingApplicationModeTest >> testExitSuccess [

	self
		shouldnt: [ 
			| logger |

			logger := MemoryLogger new runDuring: [ DebuggingApplicationMode new exitSuccess ].
			self withTheOnlyOneIn: logger recordings
				do: [ :recording | self assert: ( recording printString endsWith: '[INFO] Exit application' ) ]
			]
		raise: Exit
]

{ #category : #test }
DebuggingApplicationModeTest >> testIsDebugMode [

	self assert: DebuggingApplicationMode new isDebugMode
]

{ #category : #tests }
DebuggingApplicationModeTest >> testValueOnErrorDo [

	DebuggingApplicationMode new value: [  ] onErrorDo: [ self fail ].

	self should: [ DebuggingApplicationMode new value: [ 1 / 0 ] onErrorDo: [ self fail ] ]
		raise: ZeroDivide
]
