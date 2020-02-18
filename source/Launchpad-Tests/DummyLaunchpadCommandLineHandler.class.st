Class {
	#name : #DummyLaunchpadCommandLineHandler,
	#superclass : #LaunchpadCommandLineHandler,
	#instVars : [
		'activationBlock'
	],
	#classVars : [
		'memoryLogPathConfiguredFromTest'
	],
	#category : #'Launchpad-Tests'
}

{ #category : #accessing }
DummyLaunchpadCommandLineHandler class >> commandName [

	^ 'dummy'
]

{ #category : #'private - accessing' }
DummyLaunchpadCommandLineHandler class >> defaultLogsPath [

	^ memoryLogPathConfiguredFromTest
]

{ #category : #'private - accessing' }
DummyLaunchpadCommandLineHandler class >> defaultLogsPath: aPath [

	memoryLogPathConfiguredFromTest := aPath
]

{ #category : #accessing }
DummyLaunchpadCommandLineHandler class >> description [

	^ 'this is a dummy command line handler for tests'
]

{ #category : #'private - accessing' }
DummyLaunchpadCommandLineHandler class >> logPrefix [

	^ 'dummy'
]

{ #category : #initialization }
DummyLaunchpadCommandLineHandler >> activationBlock: aBlock [

	activationBlock := aBlock
]

{ #category : #'private - activation' }
DummyLaunchpadCommandLineHandler >> basicActivate [

	activationBlock value
]

{ #category : #'private - accessing' }
DummyLaunchpadCommandLineHandler >> configurationDefinition [

	^ OrderedCollection new
		add: ( MandatoryArgument named: #mandatory );
		add: ( OptionalArgument named: 'optional' defaultingTo: 'unused-optional' );
		add: ( MandatoryArgument named: 'secret' ) asSensitive;
		yourself
]

{ #category : #initialization }
DummyLaunchpadCommandLineHandler >> initialize [

	super initialize.
	self activationBlock: [  ]
]

{ #category : #initialization }
DummyLaunchpadCommandLineHandler >> stderr: anOutputStream [

	stderr := VTermOutputDriver on: anOutputStream
]

{ #category : #initialization }
DummyLaunchpadCommandLineHandler >> stdout: anOutputStream [

	stdout := VTermOutputDriver on: anOutputStream
]
