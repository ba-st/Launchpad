Class {
	#name : #LaunchpadDebugModeOption,
	#superclass : #LaunchpadOption,
	#instVars : [
		'command'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #'instance creation' }
LaunchpadDebugModeOption class >> for: aCommand [

	^ self new initializeFor: aCommand
]

{ #category : #evaluating }
LaunchpadDebugModeOption >> evaluateWithin: context handling: argument [

	command setDebugMode
]

{ #category : #initialization }
LaunchpadDebugModeOption >> initializeFor: aCommand [

	command := aCommand
]

{ #category : #accessing }
LaunchpadDebugModeOption >> name [

	^ 'debug-mode'
]

{ #category : #accessing }
LaunchpadDebugModeOption >> summary [

	^ 'Enable the debugging mode. The image will not quit on unexpected errors. This configuration can be used in the application to improve the debugging experience.'
]
