Class {
	#name : #StackTraceTextDumper,
	#superclass : #StackTraceDumper,
	#instVars : [
		'openStreamAction'
	],
	#category : #'Launchpad-Tracing-GS64'
}

{ #category : #'instance creation' }
StackTraceTextDumper class >> on: anOpenStreamAction [

	^ self new initializeOn: anOpenStreamAction
]

{ #category : #'error handling' }
StackTraceTextDumper >> dumpStackTraceFor: anError [

	self writeStreamDo: [ :stream | 
		stream nextPutAll: (GsProcess stackReportToLevel: 300) ]
]

{ #category : #initialization }
StackTraceTextDumper >> initializeOn: anOpenStreamAction [

	openStreamAction := anOpenStreamAction
]

{ #category : #private }
StackTraceTextDumper >> writeStreamDo: dumpAction [

	openStreamAction value: dumpAction 
]
