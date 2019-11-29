"
# OptionalArgument

Used to define arguments of the format `--key=value`, defined as: `OptionalArgument named: 'key'`.
If this argument is not present the program will log an error and exit.

Supports transformations to the provided value (something like: `#asNumber` or `[:arg | arg asNumber]`).

## Example:

```smalltalk
OptionalArgument named: 'my-number-argument' defaultingTo: 0 convertingWith: #asNumber
```

or

```smalltalk
OptionalArgument named: 'my-number-argument' defaultingTo: 0 convertingWith: [ :arg | arg asNumber ]
```

Will parse `--my-number-argument=4` as the number `4`.
If no `--my-number-argument` is not present or has no `=` assignment, then the default value `0` will be used.

The parsed value will be accessible on the handler as
`self configuration at: 'my-number-argument'`
"
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

	^ self new
		initializeNamed: anArgumentName
		defaultingTo: aDefaultValue
		convertingWith: aSymbolOrBlock
]

{ #category : #evaluating }
OptionalArgument >> argumentFrom: aCommandLineHandler [

	^ converter
		cull:
			( aCommandLineHandler
				optionAt: name
				ifAbsent: [ CurrentLogger value
						logAsWarning: ( '<1s> option not provided. Defaulting to <2p>' expandMacrosWith: name with: default ).
					default
					] )
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

{ #category : #printing }
OptionalArgument >> printOn: aStream [

	aStream
		nextPutAll: '--';
		nextPutAll: name;
		nextPutAll: ' (optional)'
]
