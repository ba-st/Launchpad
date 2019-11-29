"
A command line argument must provide a command name and way to get the argument value from a command line handler
"
Class {
	#name : #CommandLineArgument,
	#superclass : #Object,
	#category : #'Application-Starter'
}

{ #category : #evaluating }
CommandLineArgument >> argumentFrom: aCommandLineHandler [

	^ self subclassResponsibility
]

{ #category : #converting }
CommandLineArgument >> asSensible [

	^ SensibleArgument over: self
]

{ #category : #logging }
CommandLineArgument >> logIn: aLogger using: configuration [

	aLogger
		logAsInfo:
			( '<1s>: <2p>' expandMacrosWith: self name asString with: ( configuration at: self name ) )
]

{ #category : #accessing }
CommandLineArgument >> name [

	^ self subclassResponsibility
]
