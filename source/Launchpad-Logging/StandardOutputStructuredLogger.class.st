Class {
	#name : #StandardOutputStructuredLogger,
	#superclass : #StandardStreamStructuredLogger,
	#category : #'Launchpad-Logging'
}

{ #category : #accessing }
StandardOutputStructuredLogger class >> instance [

	^ super instance
		  initializeOn: Stdio stdout;
		  yourself
]

{ #category : #initialization }
StandardOutputStructuredLogger >> initializeOn: standardStream [

	self name: 'stdout-json'.
	super initializeOn: standardStream
]
