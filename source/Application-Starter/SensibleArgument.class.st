"
A sensible argument will decorate another argument changing the logging so no sensitive information is exposed
"
Class {
	#name : #SensibleArgument,
	#superclass : #CommandLineArgument,
	#instVars : [
		'argument'
	],
	#category : #'Application-Starter'
}

{ #category : #'instance creation' }
SensibleArgument class >> over: anArgument [

	^ self new initializeOver: anArgument
]

{ #category : #evaluating }
SensibleArgument >> argumentFrom: aCommandLineHandler [

	^ argument argumentFrom: aCommandLineHandler
]

{ #category : #initialization }
SensibleArgument >> initializeOver: anArgument [

	argument := anArgument
]

{ #category : #logging }
SensibleArgument >> logIn: aLogger using: configuration [

	aLogger logAsInfo: ( '<1s>: *********' expandMacrosWith: self name asString )
]

{ #category : #accessing }
SensibleArgument >> name [

	^ argument name
]
