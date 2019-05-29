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
FlagArgument class >> named: anArgumentName [

	^ self new initializeNamed: anArgumentName
]

{ #category : #evaluating }
FlagArgument >> argumentFrom: aCommandLineHandler [

	^ aCommandLineHandler
		optionAt: name
		ifPresent: [ :value | self parseBooleanFrom: value inContextOf: aCommandLineHandler ]
		ifAbsent: [ aCommandLineHandler hasOption: name ]
]

{ #category : #initialization }
FlagArgument >> initializeNamed: anArgumentName [

	name := anArgumentName
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
			( '<1s> is not a valid argument for <2s>, expected --<2s>=true, --<2s>=false or --<2s>'
				expandMacrosWith: aString
				with: name )
]

{ #category : #printing }
FlagArgument >> printOn: aStream [

	aStream
		nextPutAll: '--';
		nextPutAll: name
]
