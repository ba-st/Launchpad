"
A StackTraceTextDumperTest is a test class for testing the behavior of StackTraceTextDumper
"
Class {
	#name : #StackTraceTextDumperTest,
	#superclass : #StackTraceDumperTest,
	#category : #'Launchpad-Tracing-Tests'
}

{ #category : #tests }
StackTraceTextDumperTest >> testDumpStack [

	| dumper output |

	output := String streamContents: [ :stream | 
		          dumper := StackTraceTextDumper on: [ :dumpAction | dumpAction value: stream ].
		          self generateErrorDumpingStackTraceWith: dumper
		          ].

	self assert: output notEmpty
]

{ #category : #tests }
StackTraceTextDumperTest >> testDumpStackOnFile [

	| dumper fileReference |

	fileReference := FileSystem memory / 'stack.txt'.

	dumper := StackTraceTextDumper on: [ :dumpAction | fileReference writeStreamDo: dumpAction ].
	self generateErrorDumpingStackTraceWith: dumper.

	self assert: fileReference contents notEmpty
]
