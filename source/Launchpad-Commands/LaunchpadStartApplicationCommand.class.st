Class {
	#name : #LaunchpadStartApplicationCommand,
	#superclass : #LaunchpadApplicationCommand,
	#instVars : [
		'options',
		'baseConfigurationProvider',
		'applicationMode',
		'commandServer'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #configuring }
LaunchpadStartApplicationCommand >> addConfigurationProviderFromFile: aFileReference [

	baseConfigurationProvider := ConfigurationFromSettingsFileProvider loading: aFileReference
		                             chainedWith: baseConfigurationProvider
]

{ #category : #accessing }
LaunchpadStartApplicationCommand >> description [

	^ 'Start the application selected via <app>.
Application configuration is made by the command-line via <parameters>, using environment variables or settings files.
Execute launchpad explain <app> to get a list of valid configuration parameters.'
]

{ #category : #configuring }
LaunchpadStartApplicationCommand >> enableStructuredLogging [

	[ 
	StandardStreamStructuredLogger onStandardOutput startFor:
		( LogRecord where: [ :record | record isInformational ] )
	] ensure: [ StandardStreamLogger onStandardOutput stop ].

	[ 
	StandardStreamStructuredLogger onStandardError startFor:
		( LogRecord where: [ :record | record isInformational not ] )
	] ensure: [ StandardStreamLogger onStandardError stop ]
]

{ #category : #evaluating }
LaunchpadStartApplicationCommand >> evaluateWithin: context [

	self handleOptionsAndWithNextArgumentIn: context do: [ :argument | 
		LaunchpadApplication applicationFor: argument
			ifFound: [ :application | self start: application within: context ]
			ifNone: [ context emitErrorAndExit: ( self unknownOptionOrApplicationMessageFor: argument ) ]
		]
]

{ #category : #initialization }
LaunchpadStartApplicationCommand >> initialize [

	super initialize.
	options := OrderedCollection
		           with: (LaunchpadHelpOption for: self)
		           with: (LaunchpadDebugModeOption for: self)
		           with: (LaunchpadSettingsFileOption for: self)
		           with: (LaunchpadStructuredLoggingOption for: self).
	options addAll: (LaunchpadOption additionalStartingOptionsFor: self).
	baseConfigurationProvider := NullConfigurationProvider new.
	applicationMode := ReleasedApplicationMode new.
	commandServer := NullCommandServer new
]

{ #category : #accessing }
LaunchpadStartApplicationCommand >> name [

	^ 'start'
]

{ #category : #accessing }
LaunchpadStartApplicationCommand >> options [

	^ options
]

{ #category : #printing }
LaunchpadStartApplicationCommand >> printCommandArgumentsOn: stream [

	super printCommandArgumentsOn: stream.
	stream
		space;
		nextPutAll: '<app> [<parameters>]'
]

{ #category : #configuring }
LaunchpadStartApplicationCommand >> setDebugMode [

	applicationMode := DebuggingApplicationMode new
]

{ #category : #private }
LaunchpadStartApplicationCommand >> start: anApplication within: context [

	| configurationProvider applicationToStart |

	configurationProvider := context configurationProviderChainedWith:
		                         ( ConfigurationFromEnvironmentProvider chainedWith:
			                           baseConfigurationProvider ).
	applicationToStart := anApplication
		                      runningIn: applicationMode
		                      configuredBy: configurationProvider
		                      controlledBy: commandServer.
	LaunchpadApplication setAsCurrentlyRunning: applicationToStart.
	applicationToStart startWithin: context
]

{ #category : #accessing }
LaunchpadStartApplicationCommand >> subcommands [

	^ #()
]

{ #category : #accessing }
LaunchpadStartApplicationCommand >> summary [

	^ 'Start the selected application'
]
