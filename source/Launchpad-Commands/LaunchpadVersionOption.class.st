Class {
	#name : #LaunchpadVersionOption,
	#superclass : #LaunchpadOption,
	#instVars : [
		'command'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #'instance creation' }
LaunchpadVersionOption class >> for: aCommand [

	^ self new initializeFor: aCommand
]

{ #category : #evaluating }
LaunchpadVersionOption >> evaluateWithin: context handling: argument [

	context outputStreamDo: [ :stream | 
		stream
			nextPutAll: 'Launchpad';
			space;
			nextPutAll: command version;
			cr
		].
	context exitSuccess
]

{ #category : #initialization }
LaunchpadVersionOption >> initializeFor: aCommand [

	command := aCommand
]

{ #category : #accessing }
LaunchpadVersionOption >> name [

	^ 'version'
]

{ #category : #accessing }
LaunchpadVersionOption >> summary [

	^ 'Print the version and exit.'
]
