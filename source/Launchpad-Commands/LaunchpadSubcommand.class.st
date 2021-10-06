Class {
	#name : #LaunchpadSubcommand,
	#superclass : #LaunchpadCommand,
	#category : #'Launchpad-Commands'
}

{ #category : #printing }
LaunchpadSubcommand >> fullCommandName [

	^ 'launchpad <1s>' expandMacrosWith: self name
]

{ #category : #printing }
LaunchpadSubcommand >> fullName [

	^ 'launchpad-<1s>' expandMacrosWith: self name
]
