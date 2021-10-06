"
A StandardStreamLoggerTest is a test class for testing the behavior of StandardStreamLogger
"
Class {
	#name : #StandardStreamLoggerTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Logging-Tests'
}

{ #category : #tests }
StandardStreamLoggerTest >> testStandardError [

	| record |

	record := LaunchpadLogRecord withMessage: 'Test error'.

	StandardStreamLogger onStandardError nextPut: record
]

{ #category : #tests }
StandardStreamLoggerTest >> testStandardErrorStreamLogger [

	StandardStreamLogger onStandardError runFor: LaunchpadLogRecord
		during: [ LaunchpadLogRecord emitInfo: 'Test' ]
]

{ #category : #tests }
StandardStreamLoggerTest >> testStandardOutput [

	| record |

	record := LaunchpadLogRecord withMessage: 'Test'.

	StandardStreamLogger onStandardOutput nextPut: record
]

{ #category : #tests }
StandardStreamLoggerTest >> testStandardOutputStreamLogger [

	StandardStreamLogger onStandardOutput runFor: LaunchpadLogRecord
		during: [ LaunchpadLogRecord emitInfo: 'Test' ]
]
