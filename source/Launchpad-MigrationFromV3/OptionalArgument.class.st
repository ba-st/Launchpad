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
	#superclass : #CommandLineArgument,
	#instVars : [
		'name',
		'default',
		'converter'
	],
	#category : #'Launchpad-MigrationFromV3-Launchpad-MigrationFromV3'
}

{ #category : #'Instance Creation' }
OptionalArgument class >> named: anArgumentName defaultingTo: aDefaultValue [

	self deprecated: 'Use OptionalConfigurationParameter'
		transformWith: 'OptionalArgument named: `@anArgumentName defaultingTo: `@aDefaultValue'
			->
			'OptionalConfigurationParameter named: `@anArgumentName describedBy: '''' defaultingTo: `@aDefaultValue'.
	^ OptionalConfigurationParameter named: anArgumentName describedBy: '' defaultingTo: aDefaultValue
]

{ #category : #'Instance Creation' }
OptionalArgument class >> named: anArgumentName defaultingTo: aDefaultValue convertingWith: aSymbolOrBlock [

	self deprecated: 'Use OptionalConfigurationParameter'
		transformWith:
			'OptionalArgument named: `@anArgumentName defaultingTo: `@aDefaultValue convertingWith: `@aSymbolOrBlock'
			->
			'OptionalConfigurationParameter named: `@anArgumentName describedBy: '''' defaultingTo: `@aDefaultValue   convertingWith: `@aSymbolOrBlock'.
	^ OptionalConfigurationParameter named: anArgumentName
		  describedBy: ''
		  defaultingTo: aDefaultValue
		  convertingWith: aSymbolOrBlock
]
