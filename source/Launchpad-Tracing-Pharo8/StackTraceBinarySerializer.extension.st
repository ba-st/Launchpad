Extension { #name : #StackTraceBinarySerializer }

{ #category : #'*Launchpad-Tracing-Pharo8' }
StackTraceBinarySerializer class >> openDebuggerOn: anExecutionStack [

	^ [ 
	  Smalltalk tools debugger
		  openOn: ( Processor activeProcess newDebugSessionNamed:
				    ( 'Materialized stack: <1s>' expandMacrosWith: anExecutionStack receiver description )
				    startedAt: anExecutionStack )
		  withFullView: true
	  ] forkNamed: 'Debugging materialized stack'
]
