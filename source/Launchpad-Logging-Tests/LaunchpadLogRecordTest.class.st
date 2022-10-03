"
A LaunchpadLogRecordTest is a test class for testing the behavior of LaunchpadLogRecord
"
Class {
	#name : #LaunchpadLogRecordTest,
	#superclass : #LaunchpadTest,
	#category : #'Launchpad-Logging-Tests'
}

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitCombinedEvents [

	self
		runMemoryLoggerDuring: [ 
			self
				should: [ 
					LaunchpadLogRecord emitInfo: 'Starting app' during: [ 
						LaunchpadLogRecord emitInfo: 'Setting up data'.
						LaunchpadLogRecord emitWarning: 'Missing data, using default.'.
						Error signal
						]
					]
				raise: Error
			]
		assertingLogRecordsMatch:
			#( '[INFO] Starting app...'
				'[INFO] Setting up data'
				'[WARNING] Missing data, using default.'
			   '[ERROR] Starting app... [FAILED]' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitDebug [

	self
		runMemoryLoggerDuring: [ LaunchpadLogRecord emitDebuggingInfo: 'Ouch!' ]
		assertingLogRecordsMatch: #( '[DEBUG] Ouch!' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitError [

	self
		runMemoryLoggerDuring: [ LaunchpadLogRecord emitError: 'Ouch!' ]
		assertingLogRecordsMatch: #( '[ERROR] Ouch!' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitInfo [

	self
		runMemoryLoggerDuring: [ LaunchpadLogRecord emitInfo: 'Starting' ]
		assertingLogRecordsMatch: #( '[INFO] Starting' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitInfoDuring [

	| wasEvaluated |

	wasEvaluated := false.
	self
		runMemoryLoggerDuring: [ LaunchpadLogRecord emitInfo: 'Starting' during: [ wasEvaluated := true ] ]
		assertingLogRecordsMatch: #( 
			'[INFO] Starting...'
			'[INFO] Starting... [DONE]' ).
	self assert: wasEvaluated
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitInfoDuringWhenActionFails [

	self
		runMemoryLoggerDuring: [ 
		self should: [ LaunchpadLogRecord emitInfo: 'Starting' during: [ Error signal ] ] raise: Error ]
		assertingLogRecordsMatch: #( 
			'[INFO] Starting...'
			'[ERROR] Starting... [FAILED]' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitStructuredDebuggingInfo [

	self
		runMemoryLoggerDuring: [ 
			LaunchpadLogRecord
				emitStructuredDebuggingInfo: 'Ouch!'
				with: [ :data | data at: #errorCode put: 1234 ]
			]
		assertingLogRecordsMatch: #( '[DEBUG] Ouch! {"errorCode":1234}' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitStructuredTraceInfo [

	self
		runMemoryLoggerDuring: [ 
			LaunchpadLogRecord
				emitStructuredTraceInfo: 'Ouch!'
				with: [ :data | data at: #errorCode put: 1234 ] ]
		assertingLogRecordsMatch: #( '[TRACE] Ouch! {"errorCode":1234}' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitTrace [

	self
		runMemoryLoggerDuring: [ LaunchpadLogRecord emitTraceInfo: 'Ouch!' ]
		assertingLogRecordsMatch: #( '[TRACE] Ouch!' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testEmitWarning [

	self
		runMemoryLoggerDuring: [ LaunchpadLogRecord emitWarning: 'Missing value, using X as default' ]
		assertingLogRecordsMatch: #( '[WARNING] Missing value, using X as default' )
]

{ #category : #tests }
LaunchpadLogRecordTest >> testPrintOneLineJsonOn [

	"Tests structured JSON formatting for log records.
	The expected output is something like:
  	{'time':'2022-06-16T11:01:54.154679-03:00','level':'INFO','message':'Enabling free disk space monitoring','process':'Morphic UI Process','limit':'50MB','notify':true}	"

	| record logLine |

	record := LaunchpadLogRecord
		          withMessage: 'Enabling free disk space monitoring'
		          andStructuredDataBy: [ :data | 
			          data
				          at: #limit put: '50MB';
				          at: #notify put: true
			          ].

	logLine := String streamContents: [ :s | record printOneLineJsonOn: s ].

	self
		assert: ( logLine beginsWith: '{"time":"' );
		assert: ( logLine includesSubstring:
					  '","level":"INFO","message":"Enabling free disk space monitoring","process":"' );
		assert: ( logLine endsWith: '","limit":"50MB","notify":true}' )
]
