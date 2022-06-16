Class {
	#name : #StandardStreamStructuredLogger,
	#superclass : #SignalLogger,
	#instVars : [
		'stream'
	],
	#category : #'Launchpad-Logging'
}

{ #category : #testing }
StandardStreamStructuredLogger class >> isAbstract [

	<ignoreForCoverage>
	^ self = StandardStreamStructuredLogger
]

{ #category : #'instance creation' }
StandardStreamStructuredLogger class >> onStandardError [

	^ StandardErrorStructuredLogger instance
]

{ #category : #'instance creation' }
StandardStreamStructuredLogger class >> onStandardOutput [

	^ StandardOutputStructuredLogger instance
]

{ #category : #initialization }
StandardStreamStructuredLogger >> initializeOn: standardStream [

	stream := ZnNewLineWriterStream on: ( ZnCharacterWriteStream on: standardStream encoding: 'utf8' ).
	stream forPlatformLineEnding
]

{ #category : #utilities }
StandardStreamStructuredLogger >> nextPut: aSignal [

	aSignal printOneLineJsonOn: stream.
	stream
		cr;
		flush
]
