"
# FlagArgument

Used to define arguments to define arguments of the format `--key`, `--key=true` or `--key=false`, defined as: `FlagArgument named: 'key'`.
When absent or set to false (case insensitive), the value will be the Boolean `false`.
When present without value or set to true (case insensitive), the value will be the boolean `true`

## Example:

```smalltalk
FlagArgument named: 'my-flag-argument'
```

Will interpret `--my-flag-argument=true` and `--my-flag-argument` as the Boolean `true`,
and `--my-flag-argument=false` or the absence of `--my-flag-argument` as `false`.

The parsed value will be accessible on the handler as
`self configuration at: 'my-flag-argument'`
"
Class {
	#name : #FlagArgument,
	#superclass : #CommandLineArgument,
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
