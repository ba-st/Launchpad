Class {
	#name : #LaunchpadLogRecord,
	#superclass : #BeaconSignal,
	#category : #'Launchpad-Logging'
}

{ #category : #actions }
LaunchpadLogRecord class >> emitDebuggingInfo: aString [

	^ ( self withMessage: aString )
		  beForDebugging;
		  emit
]

{ #category : #actions }
LaunchpadLogRecord class >> emitError: aString [

	^ ( self withMessage: aString )
		  beError;
		  emit
]

{ #category : #actions }
LaunchpadLogRecord class >> emitInfo: aString [

	^ ( self withMessage: aString ) emit
]

{ #category : #actions }
LaunchpadLogRecord class >> emitInfo: aString during: aBlock [

	self emitInfo: aString , '...'.
	[ 
	aBlock value.
	self emitInfo: aString , '... [DONE]'
	] ifCurtailed: [ self emitError: aString , '... [FAILED]' ]
]

{ #category : #actions }
LaunchpadLogRecord class >> emitTraceInfo: aString [

	^ ( self withMessage: aString )
		  beForTracing;
		  emit
]

{ #category : #actions }
LaunchpadLogRecord class >> emitWarning: aString [

	^ ( self withMessage: aString )
		  beWarning;
		  emit
]

{ #category : #'instance creation' }
LaunchpadLogRecord class >> withMessage: aString [

	^ self new initializeWithMessage: aString
]

{ #category : #private }
LaunchpadLogRecord >> beError [

	self properties at: #logLevel put: 'ERROR'
]

{ #category : #private }
LaunchpadLogRecord >> beForDebugging [

	self properties at: #logLevel put: 'DEBUG'
]

{ #category : #private }
LaunchpadLogRecord >> beForTracing [

	self properties at: #logLevel put: 'TRACE'
]

{ #category : #private }
LaunchpadLogRecord >> beWarning [

	self properties at: #logLevel put: 'WARNING'
]

{ #category : #initialization }
LaunchpadLogRecord >> initializeWithMessage: aString [

	self properties at: #messageText put: aString
]

{ #category : #testing }
LaunchpadLogRecord >> isInformational [

	^ self logLevel = 'INFO'
]

{ #category : #accessing }
LaunchpadLogRecord >> logLevel [

	^ self properties at: #logLevel ifAbsent: [ 'INFO' ]
]

{ #category : #accessing }
LaunchpadLogRecord >> messageText [

	^ self properties at: #messageText
]

{ #category : #printing }
LaunchpadLogRecord >> printOneLineContentsOn: stream [

	stream nextPutAll: self messageText
]

{ #category : #printing }
LaunchpadLogRecord >> printOneLineOn: stream [

	stream
		nextPutAll: self timestamp asString;
		space;
		nextPut: $[;
		nextPutAll: self logLevel;
		nextPut: $];
		space.
	self printOneLineContentsOn: stream
]
