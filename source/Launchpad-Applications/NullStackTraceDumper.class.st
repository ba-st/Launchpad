Class {
	#name : #NullStackTraceDumper,
	#superclass : #StackTraceDumper,
	#category : #'Launchpad-Applications'
}

{ #category : #'error handling' }
NullStackTraceDumper >> dumpStackTraceFor: anError [

	LaunchpadLogRecord emitWarning: 'Ignoring stack trace dumping'
]
