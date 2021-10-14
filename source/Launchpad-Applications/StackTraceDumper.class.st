Class {
	#name : #StackTraceDumper,
	#superclass : #Object,
	#category : #'Launchpad-Applications'
}

{ #category : #testing }
StackTraceDumper class >> isAbstract [

	<ignoreForCoverage>
	^ self = StackTraceDumper
]

{ #category : #'error handling' }
StackTraceDumper >> dumpStackTraceFor: anError [

	self subclassResponsibility
]
