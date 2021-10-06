Class {
	#name : #LaunchpadHelpOption,
	#superclass : #LaunchpadShortOption,
	#instVars : [
		'command'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #'instance creation' }
LaunchpadHelpOption class >> for: aCommand [

	^ self new initializeFor: aCommand
]

{ #category : #evaluating }
LaunchpadHelpOption >> evaluateWithin: context handling: argument [

	context outputStreamDo: [ :stream |
		command printHelpOn: stream ].
	context exitSuccess 
]

{ #category : #initialization }
LaunchpadHelpOption >> initializeFor: aCommand [

	command := aCommand
]

{ #category : #accessing }
LaunchpadHelpOption >> name [

	^ 'help'
]

{ #category : #accessing }
LaunchpadHelpOption >> shortName [

	^ 'h'
]

{ #category : #accessing }
LaunchpadHelpOption >> summary [

	^ 'Print this help message and exit.'
]
