Class {
	#name : #ConfigurationFromSettingsFileProvider,
	#superclass : #ConfigurationProvider,
	#category : #'Launchpad-Configuration'
}

{ #category : #testing }
ConfigurationFromSettingsFileProvider class >> canHandle: aFileReference [

	^ self subclassResponsibility
]

{ #category : #testing }
ConfigurationFromSettingsFileProvider class >> isAbstract [

	^ self = ConfigurationFromSettingsFileProvider
]

{ #category : #'instance creation' }
ConfigurationFromSettingsFileProvider class >> loading: aFileReference [

	^ self loading: aFileReference chainedWith: NullConfigurationProvider new
]

{ #category : #'instance creation' }
ConfigurationFromSettingsFileProvider class >> loading: aFileReference chainedWith: aConfigurationProvider [

	^ self subclasses detect: [ :providerClass | providerClass canHandle: aFileReference ]
		  ifFound: [ :factory | factory loading: aFileReference chainedWith: aConfigurationProvider ]
		  ifNone: [ 
			  ObjectNotFound signal:
				  ( 'Invalid format for settings file: "<1s>"' expandMacrosWith: aFileReference basename )
			  ]
]
