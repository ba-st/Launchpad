Class {
	#name : #StandardErrorLogger,
	#superclass : #StandardStreamLogger,
	#category : #'Launchpad-Logging'
}

{ #category : #accessing }
StandardErrorLogger class >> instance [

	^ super instance
		  initializeOn: Stdio stderr;
		  yourself
]
