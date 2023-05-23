"
A StackTraceBinarySerializerTest is a test class for testing the behavior of StackTraceBinarySerializer
"
Class {
	#name : #StackTraceBinarySerializerTest,
	#superclass : #StackTraceDumperTest,
	#category : #'Launchpad-Tracing-Tests'
}

{ #category : #coverage }
StackTraceBinarySerializerTest class >> classNamesNotUnderTest [

	^ #( StackTraceBinarySerializerTest )
]

{ #category : #accessing }
StackTraceBinarySerializerTest class >> defaultTimeLimit [

	^5 minute
]

{ #category : #tests }
StackTraceBinarySerializerTest >> testDumpStack [

	| dumper output |

	output := ByteArray streamContents: [ :stream |
		          dumper := StackTraceBinarySerializer on: [ :dumpAction | dumpAction value: stream ].
		          self generateErrorDumpingStackTraceWith: dumper
		          ].

	self assert: output notEmpty
]

{ #category : #tests }
StackTraceBinarySerializerTest >> testDumpStackOnFile [

	| dumper fileReference |

	fileReference := FileSystem memory / 'stack.txt'.

	dumper := StackTraceBinarySerializer on: [ :dumpAction | 
		          fileReference binaryWriteStreamDo: dumpAction ].
	self generateErrorDumpingStackTraceWith: dumper.

	fileReference binaryReadStreamDo: [ :stream | self assert: stream contents notEmpty ]
]
