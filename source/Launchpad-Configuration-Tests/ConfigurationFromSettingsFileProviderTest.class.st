"
A ConfigurationFromSettingsFileProviderTest is a test class for testing the behavior of ConfigurationFromSettingsFileProvider
"
Class {
	#name : #ConfigurationFromSettingsFileProviderTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #tests }
ConfigurationFromSettingsFileProviderTest >> testCannotLoadInvalidFormat [

	self should: [ ConfigurationFromSettingsFileProvider loading: 'invalid.dat' asFileReference ]
		raise: ObjectNotFound
		withMessageText: 'Invalid format for settings file: "invalid.dat"'
]
