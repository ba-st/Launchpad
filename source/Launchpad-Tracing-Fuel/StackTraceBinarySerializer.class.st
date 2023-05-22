Class {
	#name : #StackTraceBinarySerializer,
	#superclass : #StackTraceDumper,
	#instVars : [
		'openStreamAction'
	],
	#category : #'Launchpad-Tracing-Fuel'
}

{ #category : #coverage }
StackTraceBinarySerializer class >> classNamesNotUnderTest [

	^ #( StackTraceBinarySerializer )
]

{ #category : #'instance creation' }
StackTraceBinarySerializer class >> on: anOpenStreamAction [

	^ self new initializeOn: anOpenStreamAction
]

{ #category : #private }
StackTraceBinarySerializer >> binaryWriteStreamDo: dumpAction [

	openStreamAction value: dumpAction 
]

{ #category : #'error handling' }
StackTraceBinarySerializer >> dumpStackTraceFor: anError [

	| stackFrameToDump |

	stackFrameToDump := thisContext.
	[ stackFrameToDump receiver == anError ] whileFalse: [
		stackFrameToDump := stackFrameToDump sender.
		stackFrameToDump ifNil: [
			Error signal: ( 'Cannot find stack frame for <1p>' expandMacrosWith: anError ) ]
		].

	stackFrameToDump := stackFrameToDump copyStack.

	self binaryWriteStreamDo: [ :stream |
		self serializer
			streamFactory: [ stream ];
			object: stackFrameToDump;
			serialize
		]
]

{ #category : #initialization }
StackTraceBinarySerializer >> initializeOn: anOpenStreamAction [

	openStreamAction := anOpenStreamAction
]

{ #category : #private }
StackTraceBinarySerializer >> serializer [

	| serializer |

	serializer := FLSerializer new.
	serializer when: [ :object | object class isObsolete ] substituteBy: [ :object | nil ].
	serializer addPostMaterializationAction: [ :materialization |
		FLDebuggerStackMaterialization new
			interruptedContext: materialization root;
			signal
		].
	^ serializer
]
