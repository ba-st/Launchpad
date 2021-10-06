Class {
	#name : #LaunchpadApplicationRunningMode,
	#superclass : #Object,
	#category : #'Launchpad-Applications'
}

{ #category : #utilities }
LaunchpadApplicationRunningMode >> exitFailure [

	self subclassResponsibility
]

{ #category : #utilities }
LaunchpadApplicationRunningMode >> exitSuccess [

	self subclassResponsibility
]

{ #category : #utilities }
LaunchpadApplicationRunningMode >> handlingErrorsDuring: aBlock onErrorDo: errorHandler [

	self subclassResponsibility
]
