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

	| stackToDump |

	stackToDump := thisContext findContextSuchThat: [ :context | context receiver == anError ].

	self binaryWriteStreamDo: [ :stream |
		self serializer
			streamFactory: [ stream ];
			object: stackToDump copyStack;
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
