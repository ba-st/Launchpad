Class {
	#name : #LaunchpadListApplicationsCommand,
	#superclass : #LaunchpadSubcommand,
	#instVars : [
		'options'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #accessing }
LaunchpadListApplicationsCommand >> description [

	^ 'Lists the available applications contained in the image.'
]

{ #category : #private }
LaunchpadListApplicationsCommand >> evaluateInVerboseModeWithin: context [

	context outputStreamDo: [ :stream | 
		LaunchpadApplication availableApplications
			do: [ :application | 
				stream
					nextPutAll: application commandName;
					space;
					nextPutAll: application version;
					space;
					nextPutAll: application description
				]
			separatedBy: [ stream cr ].
		stream cr
		].
	context exitSuccess
]

{ #category : #evaluating }
LaunchpadListApplicationsCommand >> evaluateWithin: context [

	| nextArgument |

	nextArgument := context nextCommandLineArgumentIfNone: [ 
		                self listAvailableApplicationsWithin: context ].
	options detect: [ :option | option canHandle: nextArgument ]
		ifFound: [ :option | option evaluateWithin: context handling: nextArgument ]
		ifNone: [ 
			LaunchpadLogRecord emitError:
				( '<1s> unknown option: <2s>' expandMacrosWith: self name with: nextArgument ).
			context exitFailure
			]
]

{ #category : #initialization }
LaunchpadListApplicationsCommand >> initialize [

	super initialize.
	options := Array with: ( LaunchpadVerboseOption for: self ) with: ( LaunchpadHelpOption for: self )
]

{ #category : #private }
LaunchpadListApplicationsCommand >> listAvailableApplicationsWithin: context [

	context outputStreamDo: [ :stream | 
		LaunchpadApplication availableApplications do: [ :application | 
			stream nextPutAll: application commandName ]
			separatedBy: [ stream space ].
		stream cr
		].
	^ context exitSuccess
]

{ #category : #accessing }
LaunchpadListApplicationsCommand >> name [

	^ 'list'
]

{ #category : #accessing }
LaunchpadListApplicationsCommand >> options [

	^ options
]

{ #category : #accessing }
LaunchpadListApplicationsCommand >> subcommands [

	^ #()
]

{ #category : #accessing }
LaunchpadListApplicationsCommand >> summary [

	^ 'List available applications'
]
