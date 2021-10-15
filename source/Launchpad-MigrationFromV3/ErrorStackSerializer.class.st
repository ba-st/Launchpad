Class {
	#name : #ErrorStackSerializer,
	#superclass : #Object,
	#category : #'Launchpad-MigrationFromV3-Launchpad-MigrationFromV3'
}

{ #category : #testing }
ErrorStackSerializer class >> isDeprecated [

	^ true
]

{ #category : #utilities }
ErrorStackSerializer class >> serializeStackOf: aSignal to: aFile [

	self deprecated: 'Use StackTraceBinarySerializer instead '
		transformWith: 'ErrorStackSerializer serializeStackOf: `@aSignal to: `@aFile'
			-> '( StackTraceBinarySerializer on: [ :dumpAction | `@aFile binaryWriteStreamDo: dumpAction ] )
		  dumpStackTraceFor: `@aSignal'.

	^ ( StackTraceBinarySerializer on: [ :dumpAction | aFile binaryWriteStreamDo: dumpAction ] ) 
		  dumpStackTraceFor: aSignal
]
