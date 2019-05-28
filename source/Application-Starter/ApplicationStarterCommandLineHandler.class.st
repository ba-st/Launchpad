Class {
	#name : #ApplicationStarterCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'configurationCache'
	],
	#category : #'Application-Starter'
}

{ #category : #activation }
ApplicationStarterCommandLineHandler >> activate [

	self defaultLogsPath ensureCreateDirectory.
	Smalltalk logFileName: self defaultLogFile pathString.

	[ self
		logConfiguration;
		basicActivate ]
		on: self exceptionsToHandle
		do: [ :signal | 
			self dumpStackAndReport: signal.
			self exitFailure ]
]

{ #category : #activation }
ApplicationStarterCommandLineHandler >> basicActivate [

	self subclassResponsibility
]

{ #category : #'private - accessing' }
ApplicationStarterCommandLineHandler >> configuration [

	configurationCache
		ifNil: [ configurationCache := self configurationDefinition
				inject: Dictionary new
				into: [ :conf :definition | 
					conf
						at: definition name put: (definition argumentFrom: self);
						yourself ] ].
	^ configurationCache
]

{ #category : #'private - accessing' }
ApplicationStarterCommandLineHandler >> configurationDefinition [

	self subclassResponsibility 
]

{ #category : #'private - accessing' }
ApplicationStarterCommandLineHandler >> currentTimeStampString [

	^ (DateAndTime current asUTC printString copyReplaceAll: '+00:00' with: 'Z') copyReplaceAll: ':' with: ''
]

{ #category : #'private - defaults' }
ApplicationStarterCommandLineHandler >> defaultLogFile [

	^ self defaultLogsPath / ('<1s>-<2s>.log' expandMacrosWith: self logPrefix with: self currentTimeStampString)
]

{ #category : #'private - defaults' }
ApplicationStarterCommandLineHandler >> defaultLogsPath [

	^ FileLocator workingDirectory / 'logs'
]

{ #category : #'private - defaults' }
ApplicationStarterCommandLineHandler >> defaultStackDumpFile [

	^ self defaultLogsPath / ('<1s>-<2s>.fuel' expandMacrosWith: self logPrefix with: self currentTimeStampString)
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> dumpStackAndReport: exception [

	^ self
		logError:
			('Dumping Stack Due to Unexpected Error: <1s>'
				expandMacrosWith: exception messageText)
		during: [ | serializer binaryMemoryStream |

			serializer := FLSerializer newDefault.
			serializer analyzer
				when: [ :object | object class isObsolete ]
				substituteBy: [ :object | nil ].
			serializer
				addPostMaterializationAction: [ :materialization | 
					Smalltalk tools debugger
						openOn:
							(Processor activeProcess
								newDebugSessionNamed:
									('Materialized stack: <1s>' expandMacrosWith: materialization root receiver description)
								startedAt: materialization root)
						withFullView: true ].

			binaryMemoryStream := WriteStream on: (ByteArray new: 100).
			serializer
				serialize: (thisContext contextStack detect: [ :context | context receiver = exception ])
				on: binaryMemoryStream.
			self defaultStackDumpFile
				binaryWriteStreamDo: [ :stream | stream nextPutAll: binaryMemoryStream contents ] ]
]

{ #category : #'private - accessing' }
ApplicationStarterCommandLineHandler >> exceptionsToHandle [

	^ self isDebugModeEnabled
		ifTrue: [ ExceptionSet new ]
		ifFalse: [ Error ]
]

{ #category : #utility }
ApplicationStarterCommandLineHandler >> exitFailure: aMessage [

	self isDebugModeEnabled
		ifTrue: [ self error: aMessage ]
		ifFalse: [ super exitFailure: aMessage ]
]

{ #category : #'private - accessing arguments' }
ApplicationStarterCommandLineHandler >> isDebugModeEnabled [

	<ignoreForCoverage>
	^ self hasOption: 'debug-mode'
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> log: aMessage to: anOutputStream withLevel: aLogLevel [

	anOutputStream
		nextPutAll: ('[<1p>] [<2s>] <3s><n>' expandMacrosWith: DateAndTime current with: aLogLevel with: aMessage);
		flush
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> log: aMessage to: anOutputStream withLevel: aLogLevel during: aBlock [

	self log: aMessage to: anOutputStream withLevel: aLogLevel.
	[ aBlock value.
	self log: aMessage , '... [OK]' to: anOutputStream withLevel: aLogLevel ]
		ifCurtailed: [ self logError: aMessage , '... [FAILED]' ]
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> logConfiguration [

	| configuration |

	configuration := self configuration.
	configuration keys sorted
		do: [ :configurationKey | 
			self
				logInfo:
					('<1s>: <2p>'
						expandMacrosWith: configurationKey asString
						with: (configuration at: configurationKey)) ]
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> logError: anErrorMessage [

	self log: anErrorMessage to: self stderr withLevel: 'ERROR'
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> logError: anErrorMessage during: aBlock [

	self
		log: anErrorMessage
		to: self stderr
		withLevel: 'ERROR'
		during: aBlock
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> logInfo: aMessage [

	self log: aMessage to: self stdout withLevel: 'INFO'
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> logInfo: anErrorMessage during: aBlock [

	self
		log: anErrorMessage
		to: self stdout
		withLevel: 'INFO'
		during: aBlock
]

{ #category : #'private - accessing' }
ApplicationStarterCommandLineHandler >> logPrefix [

	self subclassResponsibility
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> logWarning: anErrorMessage [

	self log: anErrorMessage to: self stderr withLevel: 'WARNING'
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> logWarning: anErrorMessage during: aBlock [

	self
		log: anErrorMessage
		to: self stdout
		withLevel: 'WARNING'
		during: aBlock
]
