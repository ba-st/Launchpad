Class {
	#name : #CurrentApplicationConfiguration,
	#superclass : #DynamicVariable,
	#classVars : [
		'\t\t'
	],
	#category : #'Launchpad-Applications'
}

{ #category : #accessing }
CurrentApplicationConfiguration >> default [

	^LaunchpadApplication currentlyRunning configuration
]
