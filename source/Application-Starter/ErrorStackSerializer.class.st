Class {
	#name : #ErrorStackSerializer,
	#superclass : #Object,
	#category : #'Application-Starter'
}

{ #category : #private }
ErrorStackSerializer class >> openDebuggerOn: anExecutionStack [

	^ Smalltalk tools debugger
		openOn:
			( Processor activeProcess
				newDebugSessionNamed: ( 'Materialized stack: <1s>' expandMacrosWith: anExecutionStack receiver description )
				startedAt: anExecutionStack )
		withFullView: true
]

{ #category : #utilities }
ErrorStackSerializer class >> serializeStackOf: aSignal to: aFile [

	| binaryMemoryStream stackToDump |

	binaryMemoryStream := WriteStream on: ( ByteArray new: 100 ).
	stackToDump := thisContext contextStack detect: [ :context | context receiver = aSignal ].
	self serializer serialize: stackToDump on: binaryMemoryStream.
	aFile binaryWriteStreamDo: [ :stream | stream nextPutAll: binaryMemoryStream contents ]
]

{ #category : #private }
ErrorStackSerializer class >> serializer [

	"We specifically call the class by name instead of self,
	 because we can not serialize a reference to self on the materialization block,
	 as it would make the block reference it's context which won't be present when materialized
	 -jmaestri"

	| serializer |

	serializer := FLSerializer newDefault.
	serializer analyzer when: [ :object | object class isObsolete ] substituteBy: [ :object | nil ].
	serializer
		addPostMaterializationAction: [ :materialization | ErrorStackSerializer openDebuggerOn: materialization root ].
	^ serializer
]
