Class {
	#name : #StandardStreamLogger,
	#superclass : #SignalLogger,
	#instVars : [
		'stream'
	],
	#category : #'Launchpad-Logging'
}

{ #category : #testing }
StandardStreamLogger class >> isAbstract [

	<ignoreForCoverage>
	^ self = StandardStreamLogger
]

{ #category : #'instance creation' }
StandardStreamLogger class >> onStandardError [

	^ StandardErrorLogger instance
]

{ #category : #'instance creation' }
StandardStreamLogger class >> onStandardOutput [

	^ StandardOutputLogger instance
]

{ #category : #initialization }
StandardStreamLogger >> initializeOn: standardStream [

	stream := ZnNewLineWriterStream on: ( ZnCharacterWriteStream on: standardStream encoding: 'utf8' ).
	stream forPlatformLineEnding
]

{ #category : #utilities }
StandardStreamLogger >> nextPut: aSignal [

	aSignal printOneLineOn: stream.
	stream
		cr;
		flush
]
