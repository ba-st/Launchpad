Class {
	#name : #LaunchpadVerboseOption,
	#superclass : #LaunchpadShortOption,
	#instVars : [
		'command'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #'instance creation' }
LaunchpadVerboseOption class >> for: aCommand [

	^ self new initializeFor: aCommand
]

{ #category : #evaluating }
LaunchpadVerboseOption >> evaluateWithin: context handling: argument [

	command evaluateInVerboseModeWithin: context
]

{ #category : #initialization }
LaunchpadVerboseOption >> initializeFor: aCommand [

	command := aCommand
]

{ #category : #accessing }
LaunchpadVerboseOption >> name [

	^ 'verbose'
]

{ #category : #accessing }
LaunchpadVerboseOption >> shortName [

	^ 'v'
]

{ #category : #accessing }
LaunchpadVerboseOption >> summary [

	^ 'Produce more verbose output.'
]
