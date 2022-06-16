Class {
	#name : #LaunchpadStructuredLoggingOption,
	#superclass : #LaunchpadOption,
	#instVars : [
		'command'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #'instance creation' }
LaunchpadStructuredLoggingOption class >> for: aCommand [

	^ self new initializeFor: aCommand
]

{ #category : #evaluating }
LaunchpadStructuredLoggingOption >> evaluateWithin: context handling: argument [

	command enableStructuredLogging
]

{ #category : #initialization }
LaunchpadStructuredLoggingOption >> initializeFor: aCommand [

	command := aCommand
]

{ #category : #accessing }
LaunchpadStructuredLoggingOption >> name [

	^ 'enable-structured-logging'
]

{ #category : #accessing }
LaunchpadStructuredLoggingOption >> summary [

	^ 'Enable structured logging. When enabled the log will be emitted in JSON format.'
]
