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
	#category : #'Launchpad-MigrationFromV3'
}

{ #category : #'instance creation' }
FlagArgument class >> named: anArgumentName [

	self deprecated: 'This kind of argument is not supported anymore'
]
