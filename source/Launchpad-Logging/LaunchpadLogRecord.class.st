Class {
	#name : #LaunchpadLogRecord,
	#superclass : #BeaconSignal,
	#category : #'Launchpad-Logging'
}

{ #category : #actions }
LaunchpadLogRecord class >> emitDebuggingInfo: aString [

	^ self emitStructuredDebuggingInfo: aString with: [  ]
]

{ #category : #actions }
LaunchpadLogRecord class >> emitError: aString [

	^ ( self withMessage: aString andStructuredDataBy: [  ] )
		  beError;
		  emit
]

{ #category : #actions }
LaunchpadLogRecord class >> emitInfo: aString [

	^ ( self withMessage: aString andStructuredDataBy: [  ] ) emit
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
LaunchpadLogRecord class >> emitStructuredDebuggingInfo: aString with: aBlock [

	^ ( self withMessage: aString andStructuredDataBy: aBlock )
		  beForDebugging;
		  emit
]

{ #category : #actions }
LaunchpadLogRecord class >> emitStructuredTraceInfo: aString with: aBlock [

	^ ( self withMessage: aString andStructuredDataBy: aBlock )
		  beForTracing;
		  emit
]

{ #category : #actions }
LaunchpadLogRecord class >> emitTraceInfo: aString [

	^ self emitStructuredTraceInfo: aString with: [  ]
]

{ #category : #actions }
LaunchpadLogRecord class >> emitWarning: aString [

	^ ( self withMessage: aString andStructuredDataBy: [  ] )
		  beWarning;
		  emit
]

{ #category : #'instance creation' }
LaunchpadLogRecord class >> withMessage: aString andStructuredDataBy: aBlock [

	^ self new initializeWithMessage: aString andStructuredDataBy: aBlock
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
LaunchpadLogRecord >> initializeWithMessage: aString andStructuredDataBy: aBlock [

	| data |

	self properties at: #messageText put: aString.
	data := OrderedDictionary new.
	aBlock cull: data.
	self properties at: #data put: data
]

{ #category : #testing }
LaunchpadLogRecord >> isInformational [

	^ #( 'INFO' 'TRACE' 'DEBUG' ) includes: self logLevel
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

	stream nextPutAll: self messageText.
	( self properties at: #data ) ifNotEmpty: [ :data | 
		stream
			space;
			nextPutAll: ( NeoJSONWriter toString: data )
		]
]

{ #category : #printing }
LaunchpadLogRecord >> printOneLineJsonOn: stream [

	| json |

	json := OrderedDictionary new.
	json
		at: #time put: self timestamp asString;
		at: #level put: self logLevel;
		at: #message put: self messageText;
		at: #process put: self processId.

	( self properties at: #data ) keysAndValuesDo: [ :key :value | json at: key put: value ].

	stream nextPutAll: ( NeoJSONWriter toString: json )
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
