Class {
	#name : #StackTraceTextDumper,
	#superclass : #StackTraceDumper,
	#instVars : [
		'openStreamAction'
	],
	#category : #'Launchpad-Tracing'
}

{ #category : #'instance creation' }
StackTraceTextDumper class >> on: anOpenStreamAction [

	^ self new initializeOn: anOpenStreamAction
]

{ #category : #'error handling' }
StackTraceTextDumper >> dumpStackTraceFor: anError [

	self writeStreamDo: [ :stream | 
		( thisContext contextStack detect: [ :context | context receiver = anError ] ) errorReportOn:
			stream ]
]

{ #category : #initialization }
StackTraceTextDumper >> initializeOn: anOpenStreamAction [

	openStreamAction := anOpenStreamAction
]

{ #category : #private }
StackTraceTextDumper >> writeStreamDo: dumpAction [

	openStreamAction value: dumpAction 
]
