Class {
	#name : 'CurrentlyRunningLaunchpadApplication',
	#superclass : 'Object',
	#instVars : [
		'binding'
	],
	#classVars : [
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

	<ignoreForCoverage>
	uniqueInstance := super new
]

{ #category : 'instance creation' }
CurrentlyRunningLaunchpadApplication class >> new [

	^uniqueInstance
]

{ #category : 'accessing' }
CurrentlyRunningLaunchpadApplication >> currentlyRunning [

	binding ifNil: [ self resetCurrentlyRunning ].
	^ binding content
]

{ #category : 'accessing' }
CurrentlyRunningLaunchpadApplication >> resetCurrentlyRunning [

	binding := Binding undefinedExplainedBy:
		               'There''s no current application running.'
]

{ #category : 'accessing' }
CurrentlyRunningLaunchpadApplication >> setAsCurrentlyRunning: anApplication [

	binding := Binding to: anApplication
]

{ #category : 'accessing' }
CurrentlyRunningLaunchpadApplication >> setAsCurrentlyRunning: anApplication during: aBlock [

	| previousBinding |
	previousBinding := binding.
	binding := Binding to: anApplication.
	aBlock ensure: [ binding := previousBinding ]
]
