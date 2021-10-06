Class {
	#name : #LaunchpadApplication,
	#superclass : #Object,
	#instVars : [
		'configurationCache',
		'configurationProvider',
		'mode'
	],
	#category : #'Launchpad-Applications'
}

{ #category : #accessing }
LaunchpadApplication class >> applicationFor: commandName ifNone: aFailBlock [

	^ self availableApplications detect: [ :application | application commandName = commandName ]
		  ifNone: aFailBlock
]

{ #category : #accessing }
LaunchpadApplication class >> availableApplications [

	^ self allSubclasses reject: #isAbstract
]

{ #category : #accessing }
LaunchpadApplication class >> commandName [

	"Returns the command name to be used for starting this application"

	^ self subclassResponsibility
]

{ #category : #accessing }
LaunchpadApplication class >> configurationParameters [

	^ self subclassResponsibility
]

{ #category : #accessing }
LaunchpadApplication class >> description [

	^ self subclassResponsibility
]

{ #category : #printing }
LaunchpadApplication class >> printCommandArgumentsOn: stream [

	self configurationParameters do: [ :parameter | 
		stream space.
		parameter printAsCommandLineArgumentTemplateOn: stream
		]
]

{ #category : #printing }
LaunchpadApplication class >> printHelpOn: stream [

	( LaunchpadHelpPrinter on: stream )
		nameSectionContaining:
			( '<1s> [<2s>] - <3s>' expandMacrosWith: self commandName
				  with: self version
				  with: self description );
		synopsysSectionFor: self commandName
		withArguments: [ :printer | self printCommandArgumentsOn: stream ];
		parametersAndEnvironmentSectionDescribing: self configurationParameters
]

{ #category : #'instance creation' }
LaunchpadApplication class >> runningIn: anApplicationMode configuredBy: aConfigurationProvider [

	^ self new initializeRunningIn: anApplicationMode configuredBy: aConfigurationProvider
]

{ #category : #accessing }
LaunchpadApplication class >> version [

	^ self subclassResponsibility
]

{ #category : #'private - activation' }
LaunchpadApplication >> basicStartWithin: context [

	self subclassResponsibility
]

{ #category : #accessing }
LaunchpadApplication >> configuration [

	configurationCache ifNil: [ 
		configurationCache := ApplicationConfiguration forAll: self class configurationParameters
			                      providedBy: configurationProvider
		].
	^ configurationCache
]

{ #category : #'error handling' }
LaunchpadApplication >> dumpStackTraceFor: anError [

	LaunchpadLogRecord emitError:
		( 'Dumping stack due to unexpected error: "<1s>"' expandMacrosWith: anError messageText ).
	self stackTraceDumper dumpStackTraceFor: anError
]

{ #category : #initialization }
LaunchpadApplication >> initializeRunningIn: anApplicationMode configuredBy: aConfigurationProvider [

	mode := anApplicationMode.
	configurationProvider := aConfigurationProvider
]

{ #category : #'private - activation' }
LaunchpadApplication >> logConfigurationWithin: context [

	LaunchpadLogRecord emitInfo: 'Obtaining configuration' during: [ 
		[ 
		self class configurationParameters do: [ :parameter | parameter logValueIn: self configuration ] ] 
			on: RequiredConfigurationNotFound
			do: [ :error | mode exitFailure ]
		]
]

{ #category : #'error handling' }
LaunchpadApplication >> stackTraceDumper [

	^ self subclassResponsibility 
]

{ #category : #'private - activation' }
LaunchpadApplication >> standardErrorStream [

	^ ZnNewLineWriterStream on: ( ZnCharacterWriteStream on: Stdio stderr encoding: 'utf8' )
]

{ #category : #activation }
LaunchpadApplication >> startWithin: context [

	mode
		handlingErrorsDuring: [ 
			self
				logConfigurationWithin: context;
				basicStartWithin: context
			]
		onErrorDo: [ :error | 
			LaunchpadLogRecord emitError:
				( 'Unexpected startup error: <1s>' expandMacrosWith: error messageText ).
			self dumpStackTraceFor: error.
			context exitFailure
			]
]
