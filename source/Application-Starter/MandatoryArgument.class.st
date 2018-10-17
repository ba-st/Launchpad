Class {
	#name : #MandatoryArgument,
	#superclass : #Object,
	#instVars : [
		'name',
		'converter'
	],
	#category : #'Application-Starter'
}

{ #category : #'Instance Creation' }
MandatoryArgument class >> named: anArgumentName [

	^ self named: anArgumentName convertingWith: #yourself
]

{ #category : #'Instance Creation' }
MandatoryArgument class >> named: anArgumentName convertingWith: aSymbolOrBlock [

	^ self new initializeNamed: anArgumentName convertingWith: aSymbolOrBlock
]

{ #category : #Evaluating }
MandatoryArgument >> argumentFrom: aCommandLineHandler [

	^ converter
		cull:
			(aCommandLineHandler
				optionAt: name
				ifAbsent: [ aCommandLineHandler logError: ('<1s> option not provided. You must provide one.' expandMacrosWith: name).
					aCommandLineHandler exitFailure: ('<1s> option not present' expandMacrosWith: name) ])
]

{ #category : #initialization }
MandatoryArgument >> initializeNamed: anArgumentName convertingWith: aSymbolOrBlock [

	name := anArgumentName.
	converter := aSymbolOrBlock
]

{ #category : #Evaluating }
MandatoryArgument >> name [

	^ name
]
