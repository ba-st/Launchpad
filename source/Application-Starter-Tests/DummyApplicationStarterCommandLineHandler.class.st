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
DummyApplicationStarterCommandLineHandler >> configuration [

	^ Dictionary new
		at: #optional put: (self optionNamed: 'optional' defaultingTo: 'unused-optional');
		at: #mandatory put: (self mandatoryOptionNamed: 'mandatory');
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
