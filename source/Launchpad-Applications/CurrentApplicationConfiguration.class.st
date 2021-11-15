Class {
	#name : #CurrentApplicationConfiguration,
	#superclass : #DynamicVariable,
	#category : #'Launchpad-Applications'
}

{ #category : #accessing }
CurrentApplicationConfiguration >> default [

	^LaunchpadApplication currentlyRunning configuration
]
