Class {
	#name : #LaunchpadStartApplicationCommand,
	#superclass : #LaunchpadSubcommand,
	#instVars : [
		'options',
		'baseConfigurationProvider',
		'applicationMode'
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

{ #category : #evaluating }
LaunchpadStartApplicationCommand >> evaluateWithin: context [

	| nextArgument |

	nextArgument := context nextCommandLineArgumentIfNone: [ 
		                LaunchpadLogRecord emitError: 'Missing application name or option.'.
		                context exitFailure
		                ].

	options
		detect: [ :option | option canHandle: nextArgument ]
		ifFound: [ :option | 
			option evaluateWithin: context handling: nextArgument.
			self evaluateWithin: context
			]
		ifNone: [ 
			| application |

			application := LaunchpadApplication applicationFor: nextArgument ifNone: [ 
				               LaunchpadLogRecord emitError:
					               ( '<1s> unknown <2?option:application>: <3s>' expandMacrosWith: self name
						                 with: ( nextArgument beginsWith: '-' )
						                 with: nextArgument ).
				               context exitFailure
				               ].
			self start: application within: context
			]
]

{ #category : #initialization }
LaunchpadStartApplicationCommand >> initialize [

	super initialize.
	options := Array with: ( LaunchpadHelpOption for: self )
		           with: ( LaunchpadDebugModeOption for: self )
		           with: ( LaunchpadSettingsFileOption for: self ).
	baseConfigurationProvider := NullConfigurationProvider new.
	applicationMode := ReleasedApplicationMode new
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

	| configurationProvider |

	configurationProvider := context configurationProviderChainedWith:
		                         ( ConfigurationFromEnvironmentProvider chainedWith:
			                           baseConfigurationProvider ).

	( anApplication runningIn: applicationMode configuredBy: configurationProvider ) startWithin:
		context
]

{ #category : #accessing }
LaunchpadStartApplicationCommand >> subcommands [

	^ #()
]

{ #category : #accessing }
LaunchpadStartApplicationCommand >> summary [

	^ 'Start the selected application'
]