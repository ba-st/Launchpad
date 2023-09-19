Class {
	#name : #LaunchpadRootCommand,
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
LaunchpadRootCommand class >> commandName [

	^ 'launchpad'
]

{ #category : #accessing }
LaunchpadRootCommand class >> summary [

	^ 'A minimal application launcher'
]

{ #category : #accessing }
LaunchpadRootCommand class >> version [

	^ Version ifNil: [ '' ]
]

{ #category : #accessing }
LaunchpadRootCommand class >> version: aVersion [

	Version := aVersion
]

{ #category : #accessing }
LaunchpadRootCommand >> description [

	^ 'A command-line interface to start, list, and explain the applications available within the image.'
]

{ #category : #evaluating }
LaunchpadRootCommand >> evaluateWithin: context [

	self handleOptionsAndWithNextArgumentIn: context do: [ :argument | 
		subcommands detect: [ :subcommand | subcommand canHandle: argument ]
			ifFound: [ :subcommand | subcommand evaluateWithin: context ]
			ifNone: [ context emitErrorAndExit: ( self unkownCommandMessageFor: argument ) ]
		]
]

{ #category : #accessing }
LaunchpadRootCommand >> fullCommandName [

	^ self name
]

{ #category : #accessing }
LaunchpadRootCommand >> fullName [

	^ self name
]

{ #category : #initialization }
LaunchpadRootCommand >> initialize [

	super initialize.
	options := Array with: ( LaunchpadVersionOption for: self ) with: ( LaunchpadHelpOption for: self ).
	subcommands := Array with: LaunchpadStartApplicationCommand new
		               with: LaunchpadListApplicationsCommand new
		               with: LaunchpadExplainApplicationCommand new
]

{ #category : #accessing }
LaunchpadRootCommand >> name [

	^ self class commandName
]

{ #category : #private }
LaunchpadRootCommand >> nextCommandLineArgumentIn: context [

	^ context nextCommandLineArgumentIfNone: [ context emitErrorAndExit: 'Missing command or option.' ]
]

{ #category : #accessing }
LaunchpadRootCommand >> options [
	
	^options
]

{ #category : #accessing }
LaunchpadRootCommand >> subcommands [

	^ subcommands
]

{ #category : #accessing }
LaunchpadRootCommand >> summary [

	^ self class summary
]

{ #category : #private }
LaunchpadRootCommand >> unkownCommandMessageFor: argument [

	^ '<1s> unknown <2?option:command>: <3s>' expandMacrosWith: self name
		  with: ( argument beginsWith: '-' )
		  with: argument
]

{ #category : #accessing }
LaunchpadRootCommand >> version [

	^ self class version
]
