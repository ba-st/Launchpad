Class {
	#name : #ConfigurationFromEnvironmentProvider,
	#superclass : #ConfigurationProvider,
	#instVars : [
		'nextProvider'
	],
	#category : #'Launchpad-Configuration'
}

{ #category : #'instance creation' }
ConfigurationFromEnvironmentProvider class >> chainedWith: aConfigurationProvider [

	^ super new initializeChainedWith: aConfigurationProvider
]

{ #category : #'instance creation' }
ConfigurationFromEnvironmentProvider class >> new [

	^ self chainedWith: NullConfigurationProvider new
]

{ #category : #initialization }
ConfigurationFromEnvironmentProvider >> initializeChainedWith: aConfigurationProvider [

	nextProvider := aConfigurationProvider
]

{ #category : #initialization }
ConfigurationFromEnvironmentProvider >> reloadConfiguration [

	^ nextProvider reloadConfiguration
]

{ #category : #resolving }
ConfigurationFromEnvironmentProvider >> valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock [

	^ OSPlatform current environment at: aConfigurationParameter environmentVariableName
		  ifPresent: aPresentBlock
		  ifAbsent: [ 
		  nextProvider valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock ]
]
