Class {
	#name : #CurrentApplicationConfiguration,
	#superclass : #DynamicVariable,
	#category : #'Launchpad-Applications'
}

{ #category : #accessing }
CurrentApplicationConfiguration class >> default [

	^ LaunchpadApplication currentlyRunning configuration
]

{ #category : #accessing }
CurrentApplicationConfiguration >> default [

	^ self class default
]
