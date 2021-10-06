Class {
	#name : #LaunchpadMainCommand,
	#superclass : #LaunchpadCommand,
	#instVars : [
		'options',
		'subcommands'
	],
	#classVars : [
		'Version'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #accessing }
LaunchpadMainCommand class >> commandName [

	^ 'launchpad'
]

{ #category : #initialization }
LaunchpadMainCommand class >> initialize [

	self version: (VersionFromRepositoryResolver new valueFor: #BaselineOfLaunchpad)
]

{ #category : #accessing }
LaunchpadMainCommand class >> summary [

	^ 'A minimal application launcher'
]

{ #category : #accessing }
LaunchpadMainCommand class >> version [

	^ Version ifNil: [ '' ]
]

{ #category : #accessing }
LaunchpadMainCommand class >> version: aVersion [

	Version := aVersion
]

{ #category : #accessing }
LaunchpadMainCommand >> description [

	^ 'Launchpad provides a command-line handler used to start, list, and explain the available applications contained in the image.'
]

{ #category : #evaluating }
LaunchpadMainCommand >> evaluateWithin: context [

	| nextArgument |

	nextArgument := context nextCommandLineArgumentIfNone: [ 
		                LaunchpadLogRecord emitError: 'Missing command or option.'.
		                context exitFailure
		                ].
	options detect: [ :option | option canHandle: nextArgument ]
		ifFound: [ :option | option evaluateWithin: context handling: nextArgument ]
		ifNone: [ 
			subcommands detect: [ :subcommand | subcommand canHandle: nextArgument ]
				ifFound: [ :subcommand | subcommand evaluateWithin: context ]
				ifNone: [ 
					LaunchpadLogRecord emitError:
						( '<1s> unknown <2?option:command>: <3s>' expandMacrosWith: self name
							  with: ( nextArgument beginsWith: '-' )
							  with: nextArgument ).
					context exitFailure
					]
			]
]

{ #category : #accessing }
LaunchpadMainCommand >> fullCommandName [

	^ self name
]

{ #category : #accessing }
LaunchpadMainCommand >> fullName [

	^ self name
]

{ #category : #initialization }
LaunchpadMainCommand >> initialize [

	super initialize.
	options := Array with: ( LaunchpadVersionOption for: self ) with: ( LaunchpadHelpOption for: self ).
	subcommands := Array with: LaunchpadStartApplicationCommand new
		               with: LaunchpadListApplicationsCommand new
		               with: LaunchpadExplainApplicationCommand new
]

{ #category : #accessing }
LaunchpadMainCommand >> name [

	^ self class commandName
]

{ #category : #accessing }
LaunchpadMainCommand >> options [
	
	^options
]

{ #category : #accessing }
LaunchpadMainCommand >> subcommands [

	^ subcommands
]

{ #category : #accessing }
LaunchpadMainCommand >> summary [

	^ self class summary
]

{ #category : #versions }
LaunchpadMainCommand >> version [

	^ self class version
]
