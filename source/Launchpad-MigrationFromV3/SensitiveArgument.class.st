"
A Sensitive argument will decorate another argument changing the logging so no sensitive information is exposed
"
Class {
	#name : #SensitiveArgument,
	#superclass : #CommandLineArgument,
	#category : #'Launchpad-MigrationFromV3'
}

{ #category : #'instance creation' }
SensitiveArgument class >> over: anArgument [

	self deprecated: 'Use SensitiveConfigurationParameter'
		transformWith:
		'SensitiveArgument over: `@parameter' -> 'SensitiveConfigurationParameter over: `@parameter'.
	^ SensitiveConfigurationParameter over: anArgument
]
