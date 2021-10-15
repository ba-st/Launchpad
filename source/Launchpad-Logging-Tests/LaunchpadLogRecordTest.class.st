"
A LaunchpadLogRecordTest is a test class for testing the behavior of LaunchpadLogRecord
"
Class {
	#name : #LaunchpadLogRecordTest,
	#superclass : #TestCase,
	#instVars : [
		'logger'
	],
	#category : #'Launchpad-Logging-Tests'
}

{ #category : #running }
LaunchpadLogRecordTest >> setUp [

	super setUp.
	logger := MemoryLogger new
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitCombinedEvents [

	logger runDuring: [ 
		self
			should: [ 
				LaunchpadLogRecord emitInfo: 'Starting app' during: [ 
					LaunchpadLogRecord emitInfo: 'Setting up data'.
					LaunchpadLogRecord emitWarning: 'Missing data, using default.'.
					Error signal
					]
				]
			raise: Error
		].

	self
		assert: logger recordings size equals: 4;
		assert: ( logger recordings first printString endsWith: '[INFO] Starting app...' );
		assert: ( logger recordings second printString endsWith: '[INFO] Setting up data' );
		assert: ( logger recordings third printString endsWith: '[WARNING] Missing data, using default.' );
		assert: ( logger recordings last printString endsWith: '[ERROR] Starting app... [FAILED]' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitError [

	logger runDuring: [ LaunchpadLogRecord emitError: 'Ouch!' ].

	self
		assert: logger recordings size equals: 1;
		assert: ( logger recordings first printString endsWith: '[ERROR] Ouch!' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitInfo [

	logger runDuring: [ LaunchpadLogRecord emitInfo: 'Starting' ].

	self
		assert: logger recordings size equals: 1;
		assert: ( logger recordings first printString endsWith: '[INFO] Starting' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitInfoDuring [

	| wasEvaluated |

	wasEvaluated := false.
	logger runDuring: [ LaunchpadLogRecord emitInfo: 'Starting' during: [ wasEvaluated := true ] ].

	self
		assert: wasEvaluated;
		assert: logger recordings size equals: 2;
		assert: ( logger recordings first printString endsWith: '[INFO] Starting...' );
		assert: ( logger recordings last printString endsWith: '[INFO] Starting... [DONE]' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitInfoDuringWhenActionFails [

	logger runDuring: [ 
		self should: [ LaunchpadLogRecord emitInfo: 'Starting' during: [ Error signal ] ] raise: Error ].

	self
		assert: logger recordings size equals: 2;
		assert: ( logger recordings first printString endsWith: '[INFO] Starting...' );
		assert: ( logger recordings last printString endsWith: '[ERROR] Starting... [FAILED]' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitWarning [

	logger runDuring: [ LaunchpadLogRecord emitWarning: 'Missing value, using X as default' ].

	self
		assert: logger recordings size equals: 1;
		assert:
			( logger recordings first printString endsWith: '[WARNING] Missing value, using X as default' )
]
