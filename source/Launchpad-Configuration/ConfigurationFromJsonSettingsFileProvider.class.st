Class {
	#name : #ConfigurationFromJsonSettingsFileProvider,
	#superclass : #ConfigurationFromSettingsFileProvider,
	#instVars : [
		'fileReference',
		'json',
		'nextProvider'
	],
	#category : #'Launchpad-Configuration'
}

{ #category : #testing }
ConfigurationFromJsonSettingsFileProvider class >> canHandle: aFileReference [

	^ aFileReference extension = 'json'
]

{ #category : #'instance creation' }
ConfigurationFromJsonSettingsFileProvider class >> loading: aJsonFileReference chainedWith: aConfigurationProvider [

	^ self new initializeLoading: aJsonFileReference chainedWith: aConfigurationProvider
]

{ #category : #initialization }
ConfigurationFromJsonSettingsFileProvider >> initializeLoading: aFileReference chainedWith: aConfigurationProvider [

	fileReference := aFileReference.
	self loadConfiguration.
	nextProvider := aConfigurationProvider
]

{ #category : #initialization }
ConfigurationFromJsonSettingsFileProvider >> loadConfiguration [

	json := [ NeoJSONObject fromString: fileReference contents ] on: NeoJSONParseError
		        do: [ :error | error return: NeoJSONObject new ]
]

{ #category : #initialization }
ConfigurationFromJsonSettingsFileProvider >> reloadConfiguration [

	self loadConfiguration.
	nextProvider reloadConfiguration
]

{ #category : #resolving }
ConfigurationFromJsonSettingsFileProvider >> valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock [

	^ ( json atPath:
		    ( aConfigurationParameter sectionsAsAttributeNames copyWith:
			      aConfigurationParameter attributeName ) ) ifNil: [ 
		  nextProvider valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock ]
		  ifNotNil: aPresentBlock
]
