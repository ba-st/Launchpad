"
A Sensitive argument will decorate another argument changing the logging so no sensitive information is exposed
"
Class {
	#name : #SensitiveArgument,
	#superclass : #CommandLineArgument,
	#instVars : [
		'argument'
	],
	#category : #'Application-Starter'
}

{ #category : #'instance creation' }
SensitiveArgument class >> over: anArgument [

	^ self new initializeOver: anArgument
]

{ #category : #evaluating }
SensitiveArgument >> argumentFrom: aCommandLineHandler [

	^ argument argumentFrom: aCommandLineHandler
]

{ #category : #initialization }
SensitiveArgument >> initializeOver: anArgument [

	argument := anArgument
]

{ #category : #logging }
SensitiveArgument >> logIn: aLogger using: configuration [

	aLogger logAsInfo: ( '<1s>: *********' expandMacrosWith: self name asString )
]

{ #category : #accessing }
SensitiveArgument >> name [

	^ argument name
]
