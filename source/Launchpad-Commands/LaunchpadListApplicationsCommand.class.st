Class {
	#name : #LaunchpadListApplicationsCommand,
	#superclass : #LaunchpadApplicationCommand,
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

	self handleOptionsAndWithNextArgumentIn: context do: [ :argument | 
		context emitErrorAndExit:
			( '<1s> unknown option: <2s>' expandMacrosWith: self name with: argument ) ]
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

{ #category : #private }
LaunchpadListApplicationsCommand >> nextCommandLineArgumentIn: context [

	^ context nextCommandLineArgumentIfNone: [ self listAvailableApplicationsWithin: context ]
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
