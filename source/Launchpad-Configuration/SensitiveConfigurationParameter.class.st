Class {
	#name : #SensitiveConfigurationParameter,
	#superclass : #ConfigurationParameter,
	#instVars : [
		'parameter'
	],
	#category : #'Launchpad-Configuration'
}

{ #category : #'instance creation' }
SensitiveConfigurationParameter class >> over: aConfigurationParameter [

	^ self new initializeOver: aConfigurationParameter
]

{ #category : #converting }
SensitiveConfigurationParameter >> asSensitive [

	^ self
]

{ #category : #initialization }
SensitiveConfigurationParameter >> initializeOver: aConfigurationParameter [

	parameter := aConfigurationParameter
]

{ #category : #logging }
SensitiveConfigurationParameter >> logValueIn: configuration [

	LaunchpadLogRecord emitInfo: ( '<1s>: **********' expandMacrosWith: self name )
]

{ #category : #accessing }
SensitiveConfigurationParameter >> name [

	^ parameter name
]

{ #category : #printing }
SensitiveConfigurationParameter >> printAsCommandLineArgumentTemplateOn: stream [

	parameter printAsCommandLineArgumentTemplateOn: stream
]

{ #category : #printing }
SensitiveConfigurationParameter >> printOn: stream [

	parameter printOn: stream
]

{ #category : #resolving }
SensitiveConfigurationParameter >> resolveValueUsing: aConfigurationProvider ifUnresolvable: aBlock [

	^ parameter resolveValueUsing: aConfigurationProvider ifUnresolvable: aBlock
]

{ #category : #accessing }
SensitiveConfigurationParameter >> sections [

	^ parameter sections
]

{ #category : #accessing }
SensitiveConfigurationParameter >> summary [

	^ parameter summary
]
