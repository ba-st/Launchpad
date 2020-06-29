Class {
	#name : #LaunchpadCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'configurationCache'
	],
	#category : #Launchpad
}

{ #category : #accessing }
LaunchpadCommandLineHandler class >> commandName [

	" Overwrite this method to provide a short name for this command handler.
	You may pass the commandName as first argument to the image to select this handler"

	self subclassResponsibility
]

{ #category : #'private - defaults' }
LaunchpadCommandLineHandler class >> currentTimeStampString [

	^ ( DateAndTime current asUTC printString copyWithoutAll: ':' ) copyReplaceAll: '+0000' with: 'Z'
]

{ #category : #'private - defaults' }
LaunchpadCommandLineHandler class >> defaultLogFile [

	| timestamp fileName |

	timestamp := self currentTimeStampString.
	fileName := self logPrefix isEmpty
		ifTrue: [ timestamp ]
		ifFalse: [ '<1s>-<2s>.log' expandMacrosWith: self logPrefix with: timestamp ].
	^ self defaultLogsPath / fileName
]

{ #category : #'private - defaults' }
LaunchpadCommandLineHandler class >> defaultLogsPath [

	"Sorry for this, but pharo is not consistent across versions with the concept of working directory.
	Bn old versions it was considered that the working directory is that of the image, which is incorrect.
	-jmaestri"

	^ ( OSEnvironment current
		at: 'PWD'
		ifPresent: #asFileReference
		ifAbsent: [ FileLocator workingDirectory ] ) / 'logs'
]

{ #category : #'private - defaults' }
LaunchpadCommandLineHandler class >> defaultStackDumpFile [

	^ self defaultLogFile withExtension: 'fuel'
]

{ #category : #accessing }
LaunchpadCommandLineHandler class >> description [

	"This method should return a short one-line description of the command"

	self subclassResponsibility
]

{ #category : #'private - logging' }
LaunchpadCommandLineHandler class >> dumpStackAndReport: aSignal [

	^ CurrentLogger value
		logAsError: ( 'Dumping Stack Due to Unexpected Error: <1s>' expandMacrosWith: aSignal messageText )
		during: [ ErrorStackSerializer serializeStackOf: aSignal to: self defaultStackDumpFile ]
]

{ #category : #accessing }
LaunchpadCommandLineHandler class >> isAbstract [

	^ self = LaunchpadCommandLineHandler
]

{ #category : #'private - accessing' }
LaunchpadCommandLineHandler class >> logPrefix [

	"A prefix for the log files, can be an empty string"

	self subclassResponsibility
]

{ #category : #activation }
LaunchpadCommandLineHandler >> activate [

	self class defaultLogsPath ensureCreateDirectory.
	Smalltalk logFileName: self class defaultLogFile pathString.
	[ self logConfiguration.
	self basicActivate
	]
		on: self exceptionsToHandle
		do: [ :signal | 
			self class dumpStackAndReport: signal.
			self exitFailure
			].
	self suspendUiIfRequired
]

{ #category : #'private - activation' }
LaunchpadCommandLineHandler >> basicActivate [

	"Here you should define the code to start up your application, all the configuration passed by command line can be accessed on the `self configuration` dictionary."

	self subclassResponsibility
]

{ #category : #'private - accessing' }
LaunchpadCommandLineHandler >> configuration [

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
LaunchpadCommandLineHandler >> configurationDefinition [

	"A collection of the arguments for this handler, wich can be MandatoryArgument, OptionalArgument or FlagArgument.
	Answer #() if you don't have arguments, but in that case you probably do not need to use this handler :)"

	self subclassResponsibility
]

{ #category : #'private - accessing' }
LaunchpadCommandLineHandler >> exceptionsToHandle [

	^ self isDebugModeEnabled
		ifTrue: [ ExceptionSet new ]
		ifFalse: [ Error ]
]

{ #category : #utilities }
LaunchpadCommandLineHandler >> exitFailure: aMessage [

	self isDebugModeEnabled
		ifTrue: [ CurrentLogger value logAsError: aMessage ]
		ifFalse: [ super exitFailure: aMessage ]
]

{ #category : #'private - accessing arguments' }
LaunchpadCommandLineHandler >> isDebugModeEnabled [

	<ignoreForCoverage>
	^ self hasOption: 'debug-mode'
]

{ #category : #'private - activation' }
LaunchpadCommandLineHandler >> logConfiguration [

	| configuration |

	configuration := self configuration.
	self configurationDefinition
		do: [ :definition | definition logIn: CurrentLogger value using: configuration ]
]

{ #category : #activation }
LaunchpadCommandLineHandler >> suspendUiIfRequired [

	<ignoreForCoverage>
	( self hasOption: 'suspend-ui' )
		ifTrue: [ UIManager default uiProcess ifNotNil: #suspend ]
]
