"
# MandatoryArgument

Used to define arguments of the format `--key=value`, defined as: `MandatoryArgument named: 'key'`.
If this argument is not present the program will log an error and exit.

Supports transformations to the provided value (something like: `#asNumber` or `[:arg | arg asNumber]`).

## Example:

```smalltalk
MandatoryArgument named: 'my-number-argument' convertingWith: #asNumber
```

or

```smalltalk
MandatoryArgument named: 'my-number-argument' convertingWith: [ :arg | arg asNumber ]
```

Will parse `--my-number-argument=4` as the number `4`.
If no `--my-number-argument` is not present or has no `=` assignment, then the program will exit.

The parsed value will be accessible on the handler as
`self configuration at: 'my-number-argument'`
"
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

{ #category : #evaluating }
MandatoryArgument >> argumentFrom: aCommandLineHandler [

	^ converter
		cull:
			( aCommandLineHandler
				optionAt: name
				ifAbsent: [ aCommandLineHandler
						logError: ( '<1s> option not provided. You must provide one.' expandMacrosWith: name ).
					aCommandLineHandler exitFailure: ( '<1s> option not present' expandMacrosWith: name )
					] )
]

{ #category : #initialization }
MandatoryArgument >> initializeNamed: anArgumentName convertingWith: aSymbolOrBlock [

	name := anArgumentName.
	converter := aSymbolOrBlock
]

{ #category : #accessing }
MandatoryArgument >> name [

	^ name
]

{ #category : #printing }
MandatoryArgument >> printOn: aStream [

	aStream
		nextPutAll: '--';
		nextPutAll: name;
		nextPutAll: ' (mandatory)'
]
