Class {
	#name : #ConfigurationFromCommandLineProvider,
	#superclass : #ConfigurationProvider,
	#instVars : [
		'commandLine',
		'nextProvider'
	],
	#category : #'Launchpad-Configuration'
}

{ #category : #'instance creation' }
ConfigurationFromCommandLineProvider class >> over: aCommandLine [

	^ self over: aCommandLine chainedWith: NullConfigurationProvider new
]

{ #category : #'instance creation' }
ConfigurationFromCommandLineProvider class >> over: aCommandLine chainedWith: aConfigurationProvider [

	^ self new initializeOver: aCommandLine chainedWith: aConfigurationProvider
]

{ #category : #initialization }
ConfigurationFromCommandLineProvider >> initializeOver: aCommandLine chainedWith: aConfigurationProvider [

	commandLine := aCommandLine.
	nextProvider := aConfigurationProvider
]

{ #category : #initialization }
ConfigurationFromCommandLineProvider >> reloadConfiguration [

	nextProvider reloadConfiguration
]

{ #category : #resolving }
ConfigurationFromCommandLineProvider >> valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock [

	^ commandLine optionAt: aConfigurationParameter commandLineArgumentName
		  ifPresent: aPresentBlock
		  ifAbsent: [ 
		  nextProvider valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock ]
]
