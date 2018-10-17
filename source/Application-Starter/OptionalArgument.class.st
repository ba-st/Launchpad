Class {
	#name : #OptionalArgument,
	#superclass : #Object,
	#instVars : [
		'name',
		'default',
		'converter'
	],
	#category : #'Application-Starter'
}

{ #category : #'Instance Creation' }
OptionalArgument class >> named: anArgumentName defaultingTo: aDefaultValue [

	^ self named: anArgumentName defaultingTo: aDefaultValue convertingWith: #yourself
]

{ #category : #'Instance Creation' }
OptionalArgument class >> named: anArgumentName defaultingTo: aDefaultValue convertingWith: aSymbolOrBlock [

	^ self new initializeNamed: anArgumentName defaultingTo: aDefaultValue convertingWith: aSymbolOrBlock
]

{ #category : #Evaluating }
OptionalArgument >> argumentFrom: aCommandLineHandler [

	^ converter
		cull:
			(aCommandLineHandler
				optionAt: name
				ifAbsent: [ aCommandLineHandler logWarning: ('<1s> option not provided. Defaulting to <2p>' expandMacrosWith: name with: default).
					default ])
]

{ #category : #initialization }
OptionalArgument >> initializeNamed: anArgumentName defaultingTo: aDefaultValue convertingWith: aSymbolOrBlock [

	name := anArgumentName.
	default := aDefaultValue.
	converter := aSymbolOrBlock
]

{ #category : #accessing }
OptionalArgument >> name [

	^ name
]
