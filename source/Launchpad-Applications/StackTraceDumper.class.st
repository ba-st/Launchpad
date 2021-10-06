Class {
	#name : #StackTraceDumper,
	#superclass : #Object,
	#category : #'Launchpad-Applications'
}

{ #category : #'error handling' }
StackTraceDumper >> dumpStackTraceFor: anError [

	self subclassResponsibility
]
