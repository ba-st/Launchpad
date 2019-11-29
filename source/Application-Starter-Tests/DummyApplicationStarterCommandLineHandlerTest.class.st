"
A DummyApplicationStarterCommandLineHandlerTest is a test class for testing the behavior of DummyApplicationStarterCommandLineHandler
"
Class {
	#name : #DummyApplicationStarterCommandLineHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'fakeStdout',
		'fakeStderr',
		'currentLogFileName',
		'memoryFileSystem',
		'activated'
	],
	#category : #'Application-Starter-Tests'
}

{ #category : #running }
DummyApplicationStarterCommandLineHandlerTest >> assert: anOutputStream matches: lines [

	anOutputStream contents lines
		with: lines
		do: [ :line :expected | self assert: ( expected match: line ) ]
]

{ #category : #running }
DummyApplicationStarterCommandLineHandlerTest >> setUp [

	super setUp.
	memoryFileSystem := FileSystem memory.
	DummyApplicationStarterCommandLineHandler defaultLogsPath: memoryFileSystem / 'logs'.
	fakeStdout := memoryFileSystem / 'stdout'.
	fakeStderr := memoryFileSystem / 'stderr'.
	currentLogFileName := Smalltalk logFileName.
	activated := false
]

{ #category : #running }
DummyApplicationStarterCommandLineHandlerTest >> tearDown [

	Smalltalk logFileName: currentLogFileName.
	super tearDown
]

{ #category : #tests }
DummyApplicationStarterCommandLineHandlerTest >> testActivation [

	CurrentLogger
		value: ( LeveledLogger outputTo: fakeStdout writeStream errorsTo: fakeStderr writeStream )
		during: [ | arguments handler |

			arguments := CommandLineArguments
				withArguments: {'start-service' . '--debug-mode' . '--optional=used-optional' . '--mandatory=something'}.
			handler := DummyApplicationStarterCommandLineHandler new commandLine: arguments.
			handler activationBlock: [ activated := true ].
			self deny: activated.
			self assert: fakeStdout contents isEmpty.
			self assert: fakeStderr contents isEmpty.
			self shouldnt: [ handler activate ] raise: Exit.
			self assert: activated.
			self assert: ( '/logs/dummy-*.log' match: Smalltalk logFileName ).
			self assert: fakeStderr contents isEmpty.
			self deny: fakeStdout contents isEmpty.
			self
				assert: fakeStdout
				matches: {'[*] [INFO] mandatory: ''something''' . '[*] [INFO] optional: ''used-optional'''}.
			self assert: ( handler configuration at: #optional ) equals: 'used-optional'.
			self assert: ( handler configuration at: #mandatory ) equals: 'something'
			]
]

{ #category : #tests }
DummyApplicationStarterCommandLineHandlerTest >> testActivationWithErrorInDebugMode [

	CurrentLogger
		value: ( LeveledLogger outputTo: fakeStdout writeStream errorsTo: fakeStderr writeStream )
		during: [ | arguments handler |

			arguments := CommandLineArguments
				withArguments: {'start-service' . '--debug-mode' . '--optional=used-optional' . '--mandatory=something'}.
			handler := DummyApplicationStarterCommandLineHandler new commandLine: arguments.
			handler
				activationBlock: [ activated := true.
					ZeroDivide signal
					].

			self deny: activated.
			self assert: fakeStdout contents isEmpty.
			self assert: fakeStderr contents isEmpty.
			self should: [ handler activate ] raise: ZeroDivide.
			self assert: activated.
			self assert: ( '/logs/dummy-*.log' match: Smalltalk logFileName ).
			self assert: fakeStderr contents isEmpty.
			self deny: fakeStdout contents isEmpty.
			self
				assert: fakeStdout
				matches: {'[*] [INFO] mandatory: ''something''' . '[*] [INFO] optional: ''used-optional'''}.
			self assert: ( handler configuration at: #optional ) equals: 'used-optional'.
			self assert: ( handler configuration at: #mandatory ) equals: 'something'
			]
]

{ #category : #tests }
DummyApplicationStarterCommandLineHandlerTest >> testActivationWithErrorWithoutDebugMode [

	CurrentLogger
		value: ( LeveledLogger outputTo: fakeStdout writeStream errorsTo: fakeStderr writeStream )
		during: [ | arguments handler |

			arguments := CommandLineArguments
				withArguments: {'start-service' . '--optional=used-optional' . '--mandatory=something'}.
			handler := DummyApplicationStarterCommandLineHandler new commandLine: arguments.
			handler
				activationBlock: [ activated := true.
					ZeroDivide signal: 'Division by Zero'
					].
			self deny: activated.
			self assert: fakeStdout contents isEmpty.
			self assert: fakeStderr contents isEmpty.
			self should: [ handler activate ] raise: Exit.
			self assert: activated.
			self assert: ( '/logs/dummy-*.log' match: Smalltalk logFileName ).
			self
				assert: fakeStderr
				matches:
					{'[*] [ERROR] Dumping Stack Due to Unexpected Error: Division by Zero'.
					'[*] [ERROR] Dumping Stack Due to Unexpected Error: Division by Zero... [OK]'}.
			self
				assert: fakeStdout
				matches: {'[*] [INFO] mandatory: ''something''' . '[*] [INFO] optional: ''used-optional'''}.
			self assert: ( handler configuration at: #optional ) equals: 'used-optional'.
			self assert: ( handler configuration at: #mandatory ) equals: 'something'.
			self
				assert:
					( ( memoryFileSystem / 'logs' ) childNames
						anySatisfy: [ :fileName | 'dummy-*.fuel' match: fileName ] )
			]
]

{ #category : #tests }
DummyApplicationStarterCommandLineHandlerTest >> testActivationWithoutMandatoryArguments [

	CurrentLogger
		value: ( LeveledLogger outputTo: fakeStdout writeStream errorsTo: fakeStderr writeStream )
		during: [ | arguments handler |

			arguments := CommandLineArguments withArguments: {'start-service' . '--optional=used-optional'}.
			handler := DummyApplicationStarterCommandLineHandler new commandLine: arguments.
			handler activationBlock: [ activated := true ].
			self deny: activated.
			self assert: fakeStdout contents isEmpty.
			self assert: fakeStderr contents isEmpty.
			self should: [ handler activate ] raise: Exit.
			self assert: fakeStdout contents isEmpty.
			self
				assert: fakeStderr
				matches: {'[*] [ERROR] mandatory option not provided. You must provide one.'}
			]
]

{ #category : #tests }
DummyApplicationStarterCommandLineHandlerTest >> testActivationWithoutOptionalArguments [

	CurrentLogger
		value: ( LeveledLogger outputTo: fakeStdout writeStream errorsTo: fakeStderr writeStream )
		during: [ | arguments handler |

			arguments := CommandLineArguments withArguments: {'start-service' . '--mandatory=something'}.
			handler := DummyApplicationStarterCommandLineHandler new commandLine: arguments.
			handler activationBlock: [ activated := true ].
			self deny: activated.
			self assert: fakeStdout contents isEmpty.
			self assert: fakeStderr contents isEmpty.
			self shouldnt: [ handler activate ] raise: Exit.
			self assert: activated.
			self assert: ( '/logs/dummy-*.log' match: Smalltalk logFileName ).
			self
				assert: fakeStderr
				matches: {'[*] [WARNING] optional option not provided. Defaulting to ''unused-optional'''}.
			self
				assert: fakeStdout
				matches: {'[*] [INFO] mandatory: ''something''' . '[*] [INFO] optional: ''unused-optional'''}.
			self assert: ( handler configuration at: #optional ) equals: 'unused-optional'.
			self assert: ( handler configuration at: #mandatory ) equals: 'something'
			]
]
