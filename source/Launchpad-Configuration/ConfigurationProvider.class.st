Class {
	#name : #ConfigurationProvider,
	#superclass : #Object,
	#category : #'Launchpad-Configuration'
}

{ #category : #initialization }
ConfigurationProvider >> reloadConfiguration [

	self subclassResponsibility
]

{ #category : #resolving }
ConfigurationProvider >> valueFor: aConfigurationParameter ifFound: aPresentBlock ifNone: aFailBlock [

	self subclassResponsibility
]
