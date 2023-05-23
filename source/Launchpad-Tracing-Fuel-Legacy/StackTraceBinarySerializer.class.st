Class {
	#name : #StackTraceBinarySerializer,
	#superclass : #StackTraceDumper,
	#instVars : [
		'openStreamAction'
	],
	#category : #'Launchpad-Tracing-Fuel-Legacy'
}

{ #category : #accessing }
StackTraceBinarySerializer class >> classNamesNotUnderTest [

	^ #( StackTraceBinarySerializer )
]

{ #category : #'instance creation' }
StackTraceBinarySerializer class >> on: anOpenStreamAction [

	^ self new initializeOn: anOpenStreamAction
]

{ #category : #actions }
StackTraceBinarySerializer class >> openDebuggerOn: anExecutionStack [

	^ [ 
	  | exception debugSession |
	  exception := anExecutionStack receiver.
	  debugSession := Processor activeProcess
		                  newDebugSessionNamed:
		                  ( 'Materialized stack: <1s>' expandMacrosWith: exception description )
		                  startedAt: anExecutionStack.
	  debugSession exception: exception.
	  StDebugger openOn: debugSession withFullView: true
	  ] forkNamed: 'Debugging materialized stack'
]

{ #category : #private }
StackTraceBinarySerializer >> binaryWriteStreamDo: dumpAction [

	openStreamAction value: dumpAction 
]

{ #category : #'error handling' }
StackTraceBinarySerializer >> dumpStackTraceFor: anError [

	| stackToDump |

	stackToDump := thisContext contextStack detect: [ :context | context receiver == anError ].
	self binaryWriteStreamDo: [ :stream | self serializer serialize: stackToDump on: stream ]
]

{ #category : #initialization }
StackTraceBinarySerializer >> initializeOn: anOpenStreamAction [

	openStreamAction := anOpenStreamAction
]

{ #category : #private }
StackTraceBinarySerializer >> serializer [

	| serializer |

	serializer := FLSerializer newDefault.
	serializer analyzer when: [ :object | object class isObsolete ] substituteBy: [ :object | nil ].
	serializer addPostMaterializationAction: [ :materialization | 
		StackTraceBinarySerializer openDebuggerOn: materialization root ].
	^ serializer
]
