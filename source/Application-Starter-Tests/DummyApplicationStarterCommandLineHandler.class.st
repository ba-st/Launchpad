Class {
	#name : #DummyApplicationStarterCommandLineHandler,
	#superclass : #ApplicationStarterCommandLineHandler,
	#instVars : [
		'memoryLogPasthConfiguredFromTest',
		'activationBlock'
	],
	#category : #'Application-Starter-Tests'
}

{ #category : #initialization }
DummyApplicationStarterCommandLineHandler >> activationBlock: aBlock [

	activationBlock := aBlock
]

{ #category : #activation }
DummyApplicationStarterCommandLineHandler >> basicActivate [

	activationBlock value
]

{ #category : #'private - accessing' }
DummyApplicationStarterCommandLineHandler >> configurationDefinition [

	^ OrderedCollection new
		add: (MandatoryArgument named: #mandatory);
		add: (OptionalArgument named: 'optional' defaultingTo: 'unused-optional');
		yourself
]

{ #category : #'private - accessing' }
DummyApplicationStarterCommandLineHandler >> defaultLogsPath [

	^ memoryLogPasthConfiguredFromTest
]

{ #category : #'private - accessing' }
DummyApplicationStarterCommandLineHandler >> defaultLogsPath: aPath [

	memoryLogPasthConfiguredFromTest := aPath
]

{ #category : #initialization }
DummyApplicationStarterCommandLineHandler >> initialize [

	super initialize.
	self activationBlock: [  ]
]

{ #category : #'private - accessing' }
DummyApplicationStarterCommandLineHandler >> logPrefix [

	^ 'dummy'
]

{ #category : #initialization }
DummyApplicationStarterCommandLineHandler >> stderr: anOutputStream [

	stderr := VTermOutputDriver on: anOutputStream
]

{ #category : #initialization }
DummyApplicationStarterCommandLineHandler >> stdout: anOutputStream [

	stdout := VTermOutputDriver on: anOutputStream
]
