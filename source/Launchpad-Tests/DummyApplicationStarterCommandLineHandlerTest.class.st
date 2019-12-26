"
A DummyApplicationStarterCommandLineHandlerTest is a test class for testing the behavior of DummyApplicationStarterCommandLineHandler
"
Class {
	#name : #DummyApplicationStarterCommandLineHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'currentLogFileName',
		'memoryFileSystem',
		'activated',
		'inMemoryStderr',
		'inMemoryStdout'
	],
	#category : #'Launchpad-Tests'
}

{ #category : #private }
DummyApplicationStarterCommandLineHandlerTest >> assert: anOutputStream matches: lines [

	anOutputStream contents lines
		with: lines
		do: [ :line :expected | self assert: ( expected match: line ) ]
]

{ #category : #private }
DummyApplicationStarterCommandLineHandlerTest >> assertPreconditions [

	self
		deny: activated;
		assert: inMemoryStdout contents isEmpty;
		assert: inMemoryStderr contents isEmpty
]

{ #category : #private }
DummyApplicationStarterCommandLineHandlerTest >> handlerWithAll: arguments evaluating: aBlock [

	| handler |

	handler := DummyApplicationStarterCommandLineHandler new
		commandLine: ( CommandLineArguments withArguments: arguments ).
	handler activationBlock: [ activated := true. aBlock value ].
	^ handler
]

{ #category : #running }
DummyApplicationStarterCommandLineHandlerTest >> redirectStdoutAndStderrToMemoryDuring: aBlock [

	CurrentLogger
		value: ( LeveledLogger outputTo: inMemoryStdout writeStream errorsTo: inMemoryStderr writeStream )
		during: aBlock
]

{ #category : #running }
DummyApplicationStarterCommandLineHandlerTest >> setUp [

	super setUp.
	memoryFileSystem := FileSystem memory.
	DummyApplicationStarterCommandLineHandler defaultLogsPath: memoryFileSystem / 'logs'.
	inMemoryStdout := memoryFileSystem / 'stdout'.
	inMemoryStderr := memoryFileSystem / 'stderr'.
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

	self
		redirectStdoutAndStderrToMemoryDuring: [ | handler |

			handler := self
				handlerWithAll: #('start-service' '--debug-mode' '--optional=used-optional' '--mandatory=something' '--secret=XXX')
				evaluating: [  ].
			self
				assertPreconditions;
				shouldnt: [ handler activate ] raise: Exit;
				assert: activated.

			self
				assert: ( '/logs/dummy-*.log' match: Smalltalk logFileName );
				assert: inMemoryStderr contents isEmpty;
				deny: inMemoryStdout contents isEmpty;
				assert: inMemoryStdout
					matches:
					#('[*] [INFO] mandatory: ''something''' '[*] [INFO] optional: ''used-optional''' '[*] [INFO] secret: *********');
				assert: ( handler configuration at: #optional ) equals: 'used-optional';
				assert: ( handler configuration at: #mandatory ) equals: 'something';
				assert: ( handler configuration at: #secret ) equals: 'XXX'
			]
]

{ #category : #tests }
DummyApplicationStarterCommandLineHandlerTest >> testActivationWithErrorInDebugMode [

	self
		redirectStdoutAndStderrToMemoryDuring: [ 
			|  handler |

			handler := self
				handlerWithAll: #('start-service' '--debug-mode' '--optional=used-optional' '--mandatory=something' '--secret=XXX')
				evaluating: [ ZeroDivide signal ].

			self
				assertPreconditions;
				should: [ handler activate ] raise: ZeroDivide;
				assert: activated.

			self
				assert: ( '/logs/dummy-*.log' match: Smalltalk logFileName );
				assert: inMemoryStderr contents isEmpty;
				deny: inMemoryStdout contents isEmpty;
				assert: inMemoryStdout
					matches:
					#('[*] [INFO] mandatory: ''something''' '[*] [INFO] optional: ''used-optional''' '[*] [INFO] secret: *********');
				assert: ( handler configuration at: #optional ) equals: 'used-optional';
				assert: ( handler configuration at: #mandatory ) equals: 'something';
				assert: ( handler configuration at: #secret ) equals: 'XXX'
			]
]

{ #category : #tests }
DummyApplicationStarterCommandLineHandlerTest >> testActivationWithErrorWithoutDebugMode [

	self
		redirectStdoutAndStderrToMemoryDuring: [ | handler |

			handler := self
				handlerWithAll: #('start-service' '--optional=used-optional' '--mandatory=something' '--secret=XXX')
				evaluating: [ ZeroDivide signal: 'Division by Zero' ].
			self
				assertPreconditions;
				should: [ handler activate ] raise: Exit;
				assert: activated.

			self
				assert: ( '/logs/dummy-*.log' match: Smalltalk logFileName );
				assert: inMemoryStderr
					matches:
					#('[*] [ERROR] Dumping Stack Due to Unexpected Error: Division by Zero' '[*] [ERROR] Dumping Stack Due to Unexpected Error: Division by Zero... [OK]');
				assert: inMemoryStdout
					matches:
					#('[*] [INFO] mandatory: ''something''' '[*] [INFO] optional: ''used-optional''' '[*] [INFO] secret: *********');
				assert: ( handler configuration at: #optional ) equals: 'used-optional';
				assert: ( handler configuration at: #mandatory ) equals: 'something';
				assert: ( handler configuration at: #secret ) equals: 'XXX';
				assert:
					( ( memoryFileSystem / 'logs' ) childNames
						anySatisfy: [ :fileName | 'dummy-*.fuel' match: fileName ] )
			]
]

{ #category : #tests }
DummyApplicationStarterCommandLineHandlerTest >> testActivationWithoutMandatoryArguments [

	self
		redirectStdoutAndStderrToMemoryDuring: [ | handler |

			handler := self handlerWithAll: #('start-service' '--optional=used-optional') evaluating: [  ].
			self
				assertPreconditions;
				should: [ handler activate ] raise: Exit;
				assert: inMemoryStdout contents isEmpty;
				assert: inMemoryStderr
					matches: {'[*] [ERROR] mandatory option not provided. You must provide one.'}
			]
]

{ #category : #tests }
DummyApplicationStarterCommandLineHandlerTest >> testActivationWithoutOptionalArguments [

	self
		redirectStdoutAndStderrToMemoryDuring: [ | handler |

			handler := self
				handlerWithAll: #('start-service' '--mandatory=something' '--secret=XXX')
				evaluating: [  ].
			self
				assertPreconditions;
				shouldnt: [ handler activate ] raise: Exit;
				assert: activated.
			self
				assert: ( '/logs/dummy-*.log' match: Smalltalk logFileName );
				assert: inMemoryStderr
					matches: #('[*] [WARNING] optional option not provided. Defaulting to ''unused-optional''');
				assert: inMemoryStdout
					matches:
					#('[*] [INFO] mandatory: ''something''' '[*] [INFO] optional: ''unused-optional''' '[*] [INFO] secret: *********');
				assert: ( handler configuration at: #optional ) equals: 'unused-optional';
				assert: ( handler configuration at: #mandatory ) equals: 'something'
			]
]
