Class {
	#name : #NullConfigurationProvider,
	#superclass : #ConfigurationProvider,
	#instVars : [
		'configurationValues'
	],
	#category : #'Launchpad-Configuration'
}

{ #category : #resolving }
NullConfigurationProvider >> atName: aConfigurationParameter putValue: aValue [

	configurationValues at: aConfigurationParameter put: aValue 
]

{ #category : #initialization }
NullConfigurationProvider >> initialize [
	"Subclasses should redefine this method to perform initializations on instance creation"
	
	configurationValues := Dictionary new.
]

{ #category : #initialization }
NullConfigurationProvider >> reloadConfiguration [

	
]

{ #category : #resolving }
NullConfigurationProvider >> valueFor: aConfigurationParameter ifFound: aFoundBlock ifNone: aFailBlock [

	^ configurationValues at: aConfigurationParameter name ifPresent: aFoundBlock ifAbsent: aFailBlock
]
