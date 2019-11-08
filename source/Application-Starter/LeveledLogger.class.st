Class {
	#name : #LeveledLogger,
	#superclass : #Object,
	#instVars : [
		'stdout',
		'stderr'
	],
	#category : #'Application-Starter'
}

{ #category : #accessing }
LeveledLogger class >> default [

	^ self outputTo: VTermOutputDriver stdout errorsTo: VTermOutputDriver stderr
]

{ #category : #accessing }
LeveledLogger class >> outputTo: anOutputStream errorsTo: anErrorStream [

	^ self new initializeOutputTo: anOutputStream errorsTo: anErrorStream
]

{ #category : #logging }
LeveledLogger >> error: anErrorMessage [

	self log: anErrorMessage to: stderr withLevel: 'ERROR'
]

{ #category : #logging }
LeveledLogger >> error: anErrorMessage during: aBlock [

	self
		log: anErrorMessage
		to: stderr
		withLevel: 'ERROR'
		during: aBlock
]

{ #category : #logging }
LeveledLogger >> info: aMessage [

	self log: aMessage to: stdout withLevel: 'INFO'
]

{ #category : #logging }
LeveledLogger >> info: anErrorMessage during: aBlock [

	self
		log: anErrorMessage
		to: stdout
		withLevel: 'INFO'
		during: aBlock
]

{ #category : #initialization }
LeveledLogger >> initializeOutputTo: anOutputStream errorsTo: anErrorStream [

	stdout := anOutputStream.
	stderr := anErrorStream
]

{ #category : #'private - logging' }
LeveledLogger >> log: aMessage to: anOutputStream withLevel: aLogLevel [

	anOutputStream
		nextPutAll: ( '[<1p>] [<2s>] <3s><n>' expandMacrosWith: DateAndTime current with: aLogLevel with: aMessage );
		flush
]

{ #category : #'private - logging' }
LeveledLogger >> log: aMessage to: anOutputStream withLevel: aLogLevel during: aBlock [

	self log: aMessage to: anOutputStream withLevel: aLogLevel.
	[ aBlock value.
	self log: aMessage , '... [OK]' to: anOutputStream withLevel: aLogLevel
	]
		ifCurtailed: [ self error: aMessage , '... [FAILED]' ]
]

{ #category : #logging }
LeveledLogger >> warning: anErrorMessage [

	self log: anErrorMessage to: stderr withLevel: 'WARNING'
]

{ #category : #logging }
LeveledLogger >> warning: anErrorMessage during: aBlock [

	self
		log: anErrorMessage
		to: stdout
		withLevel: 'WARNING'
		during: aBlock
]
