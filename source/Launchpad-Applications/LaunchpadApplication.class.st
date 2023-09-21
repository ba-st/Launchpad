Class {
	#name : #LaunchpadApplication,
	#superclass : #Object,
	#instVars : [
		'configurationCache',
		'configurationProvider',
		'mode',
		'commandServer'
	],
	#classVars : [
		'CurrentlyRunningApplicationBinding'
	],
	#category : #'Launchpad-Applications'
}

{ #category : #accessing }
LaunchpadApplication class >> applicationFor: commandName ifFound: aFoundBlock ifNone: aFailBlock [

	^ self availableApplications detect: [ :application | application commandName = commandName ]
		  ifFound: aFoundBlock
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
LaunchpadApplication class >> currentlyRunning [

	^ CurrentlyRunningApplicationBinding content
]

{ #category : #accessing }
LaunchpadApplication class >> description [

	^ self subclassResponsibility
]

{ #category : #accessing }
LaunchpadApplication class >> initialize [

	<ignoreForCoverage>
	self resetCurrentlyRunning
]

{ #category : #testing }
LaunchpadApplication class >> isAbstract [

	^ self = LaunchpadApplication
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
		nameSectionContaining: self summary;
		synopsysSectionFor: self commandName with: [ self printCommandArgumentsOn: stream ];
		parametersAndEnvironmentSectionDescribing: self configurationParameters
]

{ #category : #accessing }
LaunchpadApplication class >> resetCurrentlyRunning [

	CurrentlyRunningApplicationBinding := Binding undefinedExplainedBy:
		                                      'There''s no current application running.'
]

{ #category : #'instance creation' }
LaunchpadApplication class >> runningIn: anApplicationMode configuredBy: aConfigurationProvider controlledBy: aCommandServer [

	^ self new
		  initializeRunningIn: anApplicationMode
		  configuredBy: aConfigurationProvider
		  controlledBy: aCommandServer
]

{ #category : #accessing }
LaunchpadApplication class >> setAsCurrentlyRunning: application [

	CurrentlyRunningApplicationBinding := Binding to: application
]

{ #category : #accessing }
LaunchpadApplication class >> setAsCurrentlyRunning: application during: aBlock [

	| previousBinding |

	previousBinding := CurrentlyRunningApplicationBinding.
	CurrentlyRunningApplicationBinding := Binding to: application.
	aBlock ensure: [ CurrentlyRunningApplicationBinding := previousBinding ]
]

{ #category : #accessing }
LaunchpadApplication class >> summary [

	^ '<1s> [<2s>] - <3s>' expandMacrosWith: self commandName with: self version with: self description
]

{ #category : #accessing }
LaunchpadApplication class >> version [

	^ self subclassResponsibility
]

{ #category : #'private - activation/deactivation' }
LaunchpadApplication >> basicStartWithin: context [

	self subclassResponsibility
]

{ #category : #'private - activation/deactivation' }
LaunchpadApplication >> basicStop [

	commandServer stop
]

{ #category : #accessing }
LaunchpadApplication >> configuration [

	configurationCache ifNil: [ 
		configurationCache := ApplicationConfiguration forAll: self class configurationParameters
			                      providedBy: configurationProvider
		].
	^ configurationCache
]

{ #category : #utilities }
LaunchpadApplication >> exitFailure [ 

	self class resetCurrentlyRunning.
	mode exitFailure 
]

{ #category : #utilities }
LaunchpadApplication >> exitSuccess [

	self class resetCurrentlyRunning.
	mode exitSuccess 
]

{ #category : #initialization }
LaunchpadApplication >> initializeRunningIn: anApplicationMode configuredBy: aConfigurationProvider controlledBy: aCommandServer [

	mode := anApplicationMode.
	configurationProvider := aConfigurationProvider.
	commandServer := aCommandServer
]

{ #category : #testing }
LaunchpadApplication >> isDebugModeEnabled [

	^ mode isDebugMode
]

{ #category : #'private - activation/deactivation' }
LaunchpadApplication >> logConfigurationWithin: context [

	LogRecord emitInfo: 'Obtaining configuration' during: [ 
		[ 
		self class configurationParameters do: [ :parameter | parameter logValueIn: self configuration ] ] 
			on: RequiredConfigurationNotFound
			do: [ :error | self exitFailure ]
		]
]

{ #category : #'error handling' }
LaunchpadApplication >> stackTraceDumper [

	^ self subclassResponsibility 
]

{ #category : #'activation/deactivation' }
LaunchpadApplication >> startWithin: context [

	mode
		value: [ 
			commandServer start.
			LogRecord emitInfo: self class summary.
			self
				logConfigurationWithin: context;
				basicStartWithin: context
			]
		onErrorDo: [ :error | 
			LogRecord emitError:
				( 'Unexpected startup error: "<1s>"' expandMacrosWith: error messageText ).
			self stackTraceDumper dumpStackTraceFor: error.
			self exitFailure
			]
]

{ #category : #'activation/deactivation' }
LaunchpadApplication >> stop [

	mode value: [ self basicStop ] onErrorDo: [ :error | 
		LogRecord emitError:
			( 'Unexpected shutdown error: "<1s>"' expandMacrosWith: error messageText ).
		self stackTraceDumper dumpStackTraceFor: error.
		self exitFailure
		]
]
