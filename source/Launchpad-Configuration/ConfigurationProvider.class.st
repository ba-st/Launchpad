Class {
	#name : #ConfigurationProvider,
	#superclass : #Object,
	#category : #'Launchpad-Configuration'
}

{ #category : #testing }
ConfigurationProvider class >> isAbstract [

	<ignoreForCoverage>
	^ self =  ConfigurationProvider
]

{ #category : #initialization }
ConfigurationProvider >> reloadConfiguration [

	self subclassResponsibility
]

{ #category : #resolving }
ConfigurationProvider >> valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock [

	self subclassResponsibility
]
