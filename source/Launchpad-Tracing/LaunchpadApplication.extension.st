Extension { #name : #LaunchpadApplication }

{ #category : #'*Launchpad-Tracing' }
LaunchpadApplication >> newStackTraceDumperOnStandardError [

	| stderr |

	stderr := ZnNewLineWriterStream on: ( ZnCharacterWriteStream on: Stdio stderr encoding: 'utf8' ).
	^ StackTraceTextDumper on: [ :dumpAction | dumpAction value: stderr ]
]
