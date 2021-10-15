Class {
	#name : #StandardOutputLogger,
	#superclass : #StandardStreamLogger,
	#category : #'Launchpad-Logging'
}

{ #category : #accessing }
StandardOutputLogger class >> instance [

	^ super instance
		  initializeOn: Stdio stdout;
		  yourself
]
