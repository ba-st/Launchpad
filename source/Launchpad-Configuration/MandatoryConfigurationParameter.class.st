Class {
	#name : #MandatoryConfigurationParameter,
	#superclass : #ConfigurationParameter,
	#instVars : [
		'name',
		'summary',
		'sections',
		'converter'
	],
	#category : #'Launchpad-Configuration'
}

{ #category : #'instance creation' }
MandatoryConfigurationParameter class >> named: aName describedBy: aDescription [

	^ self named: aName describedBy: aDescription inside: #(  )
]

{ #category : #'instance creation' }
MandatoryConfigurationParameter class >> named: aName describedBy: aDescription convertingWith: aConverterAction [

	^ self named: aName
		  describedBy: aDescription
		  inside: #(  )
		  convertingWith: aConverterAction
]

{ #category : #'instance creation' }
MandatoryConfigurationParameter class >> named: aName describedBy: aDescription inside: aSectionCollection [

	^ self named: aName
		  describedBy: aDescription
		  inside: aSectionCollection
		  convertingWith: #yourself
]

{ #category : #'instance creation' }
MandatoryConfigurationParameter class >> named: aName describedBy: aDescription inside: aSectionCollection convertingWith: aConverterAction [

	self assertNotEmpty: aName and: aDescription.

	^ self new initializeNamed: aName
		  describedBy: aDescription
		  inside: aSectionCollection
		  convertingWith: aConverterAction
]

{ #category : #initialization }
MandatoryConfigurationParameter >> initializeNamed: aName describedBy: aDescription inside: aSectionCollection convertingWith: aConverterAction [

	name := aName.
	summary := aDescription.
	sections := aSectionCollection.
	converter := aConverterAction
]

{ #category : #accessing }
MandatoryConfigurationParameter >> name [

	^ name
]

{ #category : #printing }
MandatoryConfigurationParameter >> printAsCommandLineArgumentTemplateOn: stream [

	stream
		nextPutAll: '--';
		nextPutAll: self commandLineArgumentName;
		nextPutAll: '=<';
		nextPutAll: self attributeName;
		nextPutAll: '>'
]

{ #category : #printing }
MandatoryConfigurationParameter >> printOn: stream [

	stream
		nextPutAll: '--';
		nextPutAll: self commandLineArgumentName;
		cr;
		tab;
		nextPutAll: '[Mandatory]';
		space;
		nextPutAll: self summary;
		nextPut: $.
]

{ #category : #resolving }
MandatoryConfigurationParameter >> resolveValueUsing: aConfigurationProvider ifUnable: aBlock [

	^ aConfigurationProvider valueFor: self ifFound: converter ifNone: aBlock
]

{ #category : #accessing }
MandatoryConfigurationParameter >> sections [

	^ sections
]

{ #category : #accessing }
MandatoryConfigurationParameter >> summary [

	^ summary
]
