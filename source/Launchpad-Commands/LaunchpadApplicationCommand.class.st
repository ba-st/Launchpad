Class {
	#name : #LaunchpadApplicationCommand,
	#superclass : #LaunchpadCommand,
	#category : #'Launchpad-Commands'
}

{ #category : #testing }
LaunchpadApplicationCommand class >> isAbstract [

	<ignoreForCoverage>
	^ self = LaunchpadApplicationCommand
]

{ #category : #printing }
LaunchpadApplicationCommand >> fullCommandName [

	^ 'launchpad <1s>' expandMacrosWith: self name
]

{ #category : #printing }
LaunchpadApplicationCommand >> fullName [

	^ 'launchpad-<1s>' expandMacrosWith: self name
]

{ #category : #private }
LaunchpadApplicationCommand >> nextCommandLineArgumentIn: context [

	^ context nextCommandLineArgumentIfNone: [ 
		  context emitErrorAndExit: 'Missing application name or option.' ]
]

{ #category : #private }
LaunchpadApplicationCommand >> unknownOptionOrApplicationMessageFor: argument [

	^ '<1s> unknown <2?option:application>: <3s>' expandMacrosWith: self name
		  with: ( argument beginsWith: '-' )
		  with: argument
]
