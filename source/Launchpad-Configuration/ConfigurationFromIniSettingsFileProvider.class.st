Class {
	#name : #ConfigurationFromIniSettingsFileProvider,
	#superclass : #ConfigurationFromSettingsFileProvider,
	#instVars : [
		'fileReference',
		'iniData',
		'nextProvider'
	],
	#category : #'Launchpad-Configuration'
}

{ #category : #testing }
ConfigurationFromIniSettingsFileProvider class >> canHandle: aFileReference [

	^ aFileReference extension = 'ini'
]

{ #category : #'instance creation' }
ConfigurationFromIniSettingsFileProvider class >> loading: anIniFileReference chainedWith: aConfigurationProvider [

	^ self new initializeLoading: anIniFileReference chainedWith: aConfigurationProvider
]

{ #category : #initialization }
ConfigurationFromIniSettingsFileProvider >> initializeLoading: aFileReference chainedWith: aConfigurationProvider [

	fileReference := aFileReference.
	self loadConfiguration.
	nextProvider := aConfigurationProvider
]

{ #category : #initialization }
ConfigurationFromIniSettingsFileProvider >> loadConfiguration [

	fileReference readStreamDo: [ :stream | iniData := ( IniReader on: stream ) parse ]
]

{ #category : #initialization }
ConfigurationFromIniSettingsFileProvider >> reloadConfiguration [

	self loadConfiguration.
	nextProvider reloadConfiguration
]

{ #category : #resolving }
ConfigurationFromIniSettingsFileProvider >> valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock [

	^ iniData
		  at: aConfigurationParameter asIniFileSection
		  ifPresent: [ :values | 
			  values at: aConfigurationParameter attributeName
				  ifPresent: aPresentBlock
				  ifAbsent: [ 
				  nextProvider valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock ]
			  ]
		  ifAbsent: [ 
		  nextProvider valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock ]
]
