Class {
	#name : 'NullStackTraceDumper',
	#superclass : 'StackTraceDumper',
	#category : 'Launchpad-Applications',
	#package : 'Launchpad-Applications'
}

{ #category : 'error handling' }
NullStackTraceDumper >> dumpStackTraceFor: anError [

	LogRecord emitWarning: 'Ignoring stack trace dumping'
]
