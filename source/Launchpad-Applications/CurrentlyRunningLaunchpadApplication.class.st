Class {
	#name : 'CurrentlyRunningLaunchpadApplication',
	#superclass : 'Object',
	#instVars : [
		'application'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Launchpad-Applications',
	#package : 'Launchpad-Applications'
}

{ #category : 'initialization' }
CurrentlyRunningLaunchpadApplication class >> initialize [

	<ignoreForCoverage>
	self initializeUniqueInstance
]

{ #category : 'initialization' }
CurrentlyRunningLaunchpadApplication class >> initializeUniqueInstance [

	uniqueInstance := super new resetCurrentlyRunning
]

{ #category : 'instance creation' }
CurrentlyRunningLaunchpadApplication class >> new [

	^uniqueInstance
]

{ #category : 'accessing' }
CurrentlyRunningLaunchpadApplication >> currentlyRunning [

	^ application content
]

{ #category : 'accessing' }
CurrentlyRunningLaunchpadApplication >> resetCurrentlyRunning [

	application := Binding undefinedExplainedBy:
		               'There''s no current application running.'
]

{ #category : 'accessing' }
CurrentlyRunningLaunchpadApplication >> setAsCurrentlyRunning: anApplication [

	application := Binding to: anApplication
]

{ #category : 'accessing' }
CurrentlyRunningLaunchpadApplication >> setAsCurrentlyRunning: anApplication during: aBlock [

	| previousBinding |
	previousBinding := application.
	application := Binding to: anApplication.
	aBlock ensure: [ application := previousBinding ]
]
