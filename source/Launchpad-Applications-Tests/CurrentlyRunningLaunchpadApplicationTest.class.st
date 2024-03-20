Class {
	#name : 'CurrentlyRunningLaunchpadApplicationTest',
	#superclass : 'TestCase',
	#instVars : [
		'currentlyRunningLaunchpadApp'
	],
	#category : 'Launchpad-Applications-Tests',
	#package : 'Launchpad-Applications-Tests'
}

{ #category : 'running' }
CurrentlyRunningLaunchpadApplicationTest >> setUp [

	super setUp.
	CurrentlyRunningLaunchpadApplication initialize.
	currentlyRunningLaunchpadApp := CurrentlyRunningLaunchpadApplication new.
	currentlyRunningLaunchpadApp resetCurrentlyRunning
]

{ #category : 'tests' }
CurrentlyRunningLaunchpadApplicationTest >> testCurrentlyRunning [

	self
		should: [ currentlyRunningLaunchpadApp currentlyRunning ]
		raise: AssertionFailed
		withMessageText: 'There''s no current application running.'
]

{ #category : 'tests' }
CurrentlyRunningLaunchpadApplicationTest >> testResetCurrentlyRunning [

	currentlyRunningLaunchpadApp setAsCurrentlyRunning: #MockApp.
	currentlyRunningLaunchpadApp resetCurrentlyRunning.
	self
		should: [ currentlyRunningLaunchpadApp currentlyRunning ]
		raise: AssertionFailed
		withMessageText: 'There''s no current application running.'
]

{ #category : 'tests' }
CurrentlyRunningLaunchpadApplicationTest >> testSetAsCurrentlyRunning [

	currentlyRunningLaunchpadApp setAsCurrentlyRunning: #MockApp.
	self assert: currentlyRunningLaunchpadApp currentlyRunning equals: #MockApp
]

{ #category : 'tests' }
CurrentlyRunningLaunchpadApplicationTest >> testSetAsCurrentlyRunningDuring [

	currentlyRunningLaunchpadApp setAsCurrentlyRunning: #MockApp.
	currentlyRunningLaunchpadApp
		setAsCurrentlyRunning: #MockAppOther
		during: [
			self
				assert: currentlyRunningLaunchpadApp currentlyRunning
				equals: #MockAppOther ].
	self
		assert: currentlyRunningLaunchpadApp currentlyRunning
		equals: #MockApp
]
