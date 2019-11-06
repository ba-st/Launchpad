Class {
	#name : #ApplicationStarterCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'configurationCache'
	],
	#category : #'Application-Starter'
}

{ #category : #accessing }
ApplicationStarterCommandLineHandler class >> commandName [

	" Overwrite this method to provide a short name for this command handler.
	You may pass the commandName as first argument to the image to select this handler"

	self subclassResponsibility
]

{ #category : #accessing }
ApplicationStarterCommandLineHandler class >> description [

	"This method should return a short one-line description of the command"

	self subclassResponsibility
]

{ #category : #accessing }
ApplicationStarterCommandLineHandler class >> isAbstract [

	^ self = ApplicationStarterCommandLineHandler
]

{ #category : #activation }
ApplicationStarterCommandLineHandler >> activate [

	self defaultLogsPath ensureCreateDirectory.
	Smalltalk logFileName: self defaultLogFile pathString.
	[ self logConfiguration.
	self basicActivate
	]
		on: self exceptionsToHandle
		do: [ :signal | 
			self dumpStackAndReport: signal.
			self exitFailure
			].
	self suspendUiIfRequired
]

{ #category : #'private - activation' }
ApplicationStarterCommandLineHandler >> basicActivate [

	"Here you should define the code to start up your application, all the configuration passed by command line can be accessed on the `self configuration` dictionary."

	self subclassResponsibility
]

{ #category : #'private - accessing' }
ApplicationStarterCommandLineHandler >> configuration [

	configurationCache
		ifNil: [ configurationCache := self configurationDefinition
				inject: Dictionary new
				into: [ :conf :definition | 
					conf
						at: definition name put: ( definition argumentFrom: self );
						yourself
					]
			].
	^ configurationCache
]

{ #category : #'private - accessing' }
ApplicationStarterCommandLineHandler >> configurationDefinition [

	"A collection of the arguments for this handler, wich can be MandatoryArgument, OptionalArgument or FlagArgument.
	Answer #() if you don't have arguments, but in that case you probably do not need to use this handler :)"

	self subclassResponsibility 
]

{ #category : #'private - accessing' }
ApplicationStarterCommandLineHandler >> currentTimeStampString [

	^ ( DateAndTime current asUTC printString copyReplaceAll: '+00:00' with: 'Z' )
		copyReplaceAll: ':'
		with: ''
]

{ #category : #'private - defaults' }
ApplicationStarterCommandLineHandler >> defaultLogFile [

	^ self defaultLogsPath
		/ ( '<1s>-<2s>.log' expandMacrosWith: self logPrefix with: self currentTimeStampString )
]

{ #category : #'private - defaults' }
ApplicationStarterCommandLineHandler >> defaultLogsPath [

	"Sorry for this, but pharo is not consistent across versions with the concept of working directory.
	Bn old versions it was considered that the working directory is that of the image, which is incorrect.
	-jmaestri"

	^ ( OSEnvironment current
		at: 'PWD'
		ifPresent: #asFileReference
		ifAbsent: [ FileLocator workingDirectory ] ) / 'logs'
]

{ #category : #'private - defaults' }
ApplicationStarterCommandLineHandler >> defaultStackDumpFile [

	^ self defaultLogsPath
		/ ( '<1s>-<2s>.fuel' expandMacrosWith: self logPrefix with: self currentTimeStampString )
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> dumpStackAndReport: aSignal [

	^ self
		logError: ( 'Dumping Stack Due to Unexpected Error: <1s>' expandMacrosWith: aSignal messageText )
		during: [ ErrorStackSerializer serializeStackOf: aSignal to: self defaultStackDumpFile ]
]

{ #category : #'private - accessing' }
ApplicationStarterCommandLineHandler >> exceptionsToHandle [

	^ self isDebugModeEnabled
		ifTrue: [ ExceptionSet new ]
		ifFalse: [ Error ]
]

{ #category : #utilities }
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
		nextPutAll: ( '[<1p>] [<2s>] <3s><n>' expandMacrosWith: DateAndTime current with: aLogLevel with: aMessage );
		flush
]

{ #category : #'private - logging' }
ApplicationStarterCommandLineHandler >> log: aMessage to: anOutputStream withLevel: aLogLevel during: aBlock [

	self log: aMessage to: anOutputStream withLevel: aLogLevel.
	[ aBlock value.
	self log: aMessage , '... [OK]' to: anOutputStream withLevel: aLogLevel
	]
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
					( '<1s>: <2p>'
						expandMacrosWith: configurationKey asString
						with: ( configuration at: configurationKey ) )
			]
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

	"A prefix for the log files, can be an empty string"
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

{ #category : #activation }
ApplicationStarterCommandLineHandler >> suspendUiIfRequired [

	<ignoreForCoverage>
	( self hasOption: 'suspend-ui' )
		ifTrue: [ UIManager default uiProcess suspend ]
]
