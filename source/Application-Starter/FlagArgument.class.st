Class {
	#name : #FlagArgument,
	#superclass : #Object,
	#instVars : [
		'name',
		'valueWhenPresent'
	],
	#category : #'Application-Starter'
}

{ #category : #'instance creation' }
FlagArgument class >> named: anArgumentName whenPresentBe: aBoolean [

	^ self new initializeNamed: anArgumentName whenPresentBe: aBoolean
]

{ #category : #evaluating }
FlagArgument >> argumentFrom: aCommandLineHandler [

	( aCommandLineHandler hasOption: name )
		ifFalse: [ ^ valueWhenPresent not ].
	^ aCommandLineHandler
		optionAt: name
		ifPresent: [ :value | self parseBooleanFrom: value inContextOf: aCommandLineHandler ]
		ifAbsent: [ valueWhenPresent ]
]

{ #category : #initialization }
FlagArgument >> initializeNamed: anArgumentName whenPresentBe: aBoolean [

	name := anArgumentName.
	valueWhenPresent := aBoolean
]

{ #category : #accessing }
FlagArgument >> name [

	^ name
]

{ #category : #private }
FlagArgument >> parseBooleanFrom: aString inContextOf: aCommandLineHandler [

	aString asUppercase = 'TRUE'
		ifTrue: [ ^ true ].
	aString asUppercase = 'FALSE'
		ifTrue: [ ^ false ].
	aCommandLineHandler
		exitFailure:
			( '<1s> is not a valid argument for <2s>, expected true, false or nothing (<3p>)'
				expandMacrosWith: aString
				with: name
				with: valueWhenPresent )
]

{ #category : #printing }
FlagArgument >> printOn: aStream [

	aStream
		nextPutAll: '--';
		nextPutAll: name
]
