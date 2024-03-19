Class {
	#name : 'LaunchpadApplicationRunningMode',
	#superclass : 'Object',
	#category : 'Launchpad-Applications',
	#package : 'Launchpad-Applications'
}

{ #category : 'testing' }
LaunchpadApplicationRunningMode class >> isAbstract [

	<ignoreForCoverage>
	^ self = LaunchpadApplicationRunningMode
]

{ #category : 'utilities' }
LaunchpadApplicationRunningMode >> exitFailure [

	self subclassResponsibility
]

{ #category : 'utilities' }
LaunchpadApplicationRunningMode >> exitSuccess [

	self subclassResponsibility
]

{ #category : 'testing' }
LaunchpadApplicationRunningMode >> isDebugMode [

	^ self subclassResponsibility
]

{ #category : 'utilities' }
LaunchpadApplicationRunningMode >> value: aBlock onErrorDo: errorHandler [

	^ self subclassResponsibility
]
