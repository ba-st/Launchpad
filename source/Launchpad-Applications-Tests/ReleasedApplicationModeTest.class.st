"
A ReleasedApplicationModeTest is a test class for testing the behavior of ReleasedApplicationMode
"
Class {
	#name : #ReleasedApplicationModeTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Applications-Tests'
}

{ #category : #tests }
ReleasedApplicationModeTest >> testExitFailure [

	self should: [ ReleasedApplicationMode new exitFailure ]
		raise: Exit
		withExceptionDo: [ :exit | self deny: exit isSuccess ]
]

{ #category : #tests }
ReleasedApplicationModeTest >> testExitSuccess [

	self should: [ ReleasedApplicationMode new exitSuccess ]
		raise: Exit
		withExceptionDo: [ :exit | self assert: exit isSuccess ]
]

{ #category : #tests }
ReleasedApplicationModeTest >> testIsDebugMode [

	self deny: ReleasedApplicationMode new isDebugMode
]

{ #category : #tests }
ReleasedApplicationModeTest >> testValueOnErrorDo [

	| errorWasHandled |

	ReleasedApplicationMode new value: [  ] onErrorDo: [ self fail ].

	errorWasHandled := false.
	ReleasedApplicationMode new value: [ Error signal: 'Error' ] onErrorDo: [ :error | 
		errorWasHandled := true.
		self assert: error messageText equals: 'Error'
		].
	self assert: errorWasHandled
]
