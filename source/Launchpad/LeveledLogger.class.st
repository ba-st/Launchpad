Class {
	#name : #LeveledLogger,
	#superclass : #Object,
	#instVars : [
		'stdout',
		'stderr'
	],
	#category : #Launchpad
}

{ #category : #accessing }
LeveledLogger class >> default [

	^ self outputTo: VTermOutputDriver stdout errorsTo: VTermOutputDriver stderr
]

{ #category : #accessing }
LeveledLogger class >> outputTo: anOutputStream errorsTo: anErrorStream [

	^ self new initializeOutputTo: anOutputStream errorsTo: anErrorStream
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
		ifCurtailed: [ self logAsError: aMessage , '... [FAILED]' ]
]

{ #category : #logging }
LeveledLogger >> logAsError: aMessage [

	self log: aMessage to: stderr withLevel: 'ERROR'
]

{ #category : #logging }
LeveledLogger >> logAsError: aMessage during: aBlock [

	self
		log: aMessage
		to: stderr
		withLevel: 'ERROR'
		during: aBlock
]

{ #category : #logging }
LeveledLogger >> logAsInfo: aMessage [

	self log: aMessage to: stdout withLevel: 'INFO'
]

{ #category : #logging }
LeveledLogger >> logAsInfo: aMessage during: aBlock [

	self
		log: aMessage
		to: stdout
		withLevel: 'INFO'
		during: aBlock
]

{ #category : #logging }
LeveledLogger >> logAsInfo: anInformationMessage handlingErrorsDuring: aBlock [

	^ self
		log: anInformationMessage
		to: stdout
		withLevel: 'INFO'
		during: [ aBlock
				on: Error
				do: [ :signal | 
					self logAsError: signal messageText.
					signal pass
					]
			]
]

{ #category : #logging }
LeveledLogger >> logAsWarning: aMessage [

	self log: aMessage to: stderr withLevel: 'WARNING'
]

{ #category : #logging }
LeveledLogger >> logAsWarning: aMessage during: aBlock [

	self
		log: aMessage
		to: stdout
		withLevel: 'WARNING'
		during: aBlock
]
