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
	#superclass : #CommandLineArgument,
	#instVars : [
		'name',
		'converter'
	],
	#category : #'Launchpad-MigrationFromV3'
}

{ #category : #'Instance Creation' }
MandatoryArgument class >> named: anArgumentName [

	self deprecated: 'Use MandatoryConfigurationParameter'
		transformWith: 'MandatoryArgument named: `@anArgumentName  '
			-> 'MandatoryConfigurationParameter named: `@anArgumentName describedBy: '''' '.
	^ MandatoryConfigurationParameter named: anArgumentName describedBy: ''
]

{ #category : #'Instance Creation' }
MandatoryArgument class >> named: anArgumentName convertingWith: aSymbolOrBlock [

	self deprecated: 'Use MandatoryConfigurationParameter'
		transformWith: 'MandatoryArgument named: `@anArgumentName convertingWith: `@aSymbolOrBlock '
			->
			'MandatoryConfigurationParameter named: `@anArgumentName describedBy: '''' convertingWith: `@aSymbolOrBlock'.
	^ MandatoryConfigurationParameter named: anArgumentName
		  describedBy: ''
		  convertingWith: aSymbolOrBlock
]
