Class {
	#name : #OptionalConfigurationParameter,
	#superclass : #ConfigurationParameter,
	#instVars : [
		'name',
		'summary',
		'sections',
		'converter',
		'default',
		'emitWarningAction'
	],
	#category : #'Launchpad-Configuration'
}

{ #category : #'instance creation' }
OptionalConfigurationParameter class >> named: aName describedBy: aDescription defaultingTo: aDefaultValue [

	^ self named: aName
		  describedBy: aDescription
		  defaultingTo: aDefaultValue
		  convertingWith: #yourself
]

{ #category : #'instance creation' }
OptionalConfigurationParameter class >> named: aName describedBy: aDescription defaultingTo: aDefaultValue convertingWith: aConverterAction [

	^ self named: aName
		  describedBy: aDescription
		  inside: #(  )
		  defaultingTo: aDefaultValue
		  convertingWith: aConverterAction
]

{ #category : #'instance creation' }
OptionalConfigurationParameter class >> named: aName describedBy: aDescription inside: aSectionCollection defaultingTo: aDefaultValue [

	^ self named: aName
		  describedBy: aDescription
		  inside: aSectionCollection
		  defaultingTo: aDefaultValue
		  convertingWith: #yourself
]

{ #category : #'instance creation' }
OptionalConfigurationParameter class >> named: aName describedBy: aDescription inside: aSectionCollection defaultingTo: aDefaultValue convertingWith: aConverterAction [

	self assertNotEmpty: aName and: aDescription.
	^ self new initializeNamed: aName
		  describedBy: aDescription
		  inside: aSectionCollection
		  defaultingTo: aDefaultValue
		  convertingWith: aConverterAction
]

{ #category : #configuring }
OptionalConfigurationParameter >> doNotWarnWhenUsingTheDefault [

	emitWarningAction := [  ]
]

{ #category : #initialization }
OptionalConfigurationParameter >> initializeNamed: aName describedBy: aDescription inside: aSectionCollection defaultingTo: aDefaultValue convertingWith: aConverterAction [

	name := aName.
	summary := aDescription.
	sections := aSectionCollection.
	default := aDefaultValue.
	converter := aConverterAction.
	emitWarningAction := [ 
	                 LaunchpadLogRecord emitWarning:
		                 ( '"<1s>" parameter not provided. Using default.' expandMacrosWith: self name )
	                 ]
]

{ #category : #accessing }
OptionalConfigurationParameter >> name [

	^ name
]

{ #category : #printing }
OptionalConfigurationParameter >> printAsCommandLineArgumentTemplateOn: stream [

	stream
		nextPutAll: '[--';
		nextPutAll: self commandLineArgumentName;
		nextPutAll: '=<';
		nextPutAll: self attributeName;
		nextPutAll: '>]'
]

{ #category : #printing }
OptionalConfigurationParameter >> printOn: stream [

	stream
		nextPutAll: '--';
		nextPutAll: self commandLineArgumentName;
		cr;
		tab;
		nextPutAll: '[Optional]';
		space;
		nextPutAll: self summary;
		nextPut: $.
]

{ #category : #resolving }
OptionalConfigurationParameter >> resolveValueUsing: aConfigurationProvider ifUnable: aBlock [

	^ aConfigurationProvider valueFor: self ifFound: converter ifNone: [ 
		  emitWarningAction value.
		  default
		  ]
]

{ #category : #accessing }
OptionalConfigurationParameter >> sections [

	^ sections
]

{ #category : #accessing }
OptionalConfigurationParameter >> summary [

	^ '<1s>. Defaults to <2s>' expandMacrosWith: summary with: ( default = '' ifTrue: [ 'nothing' ]
			    ifFalse: [ default asString ] )
]
