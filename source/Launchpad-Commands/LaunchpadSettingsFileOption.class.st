Class {
	#name : #LaunchpadSettingsFileOption,
	#superclass : #LaunchpadOption,
	#instVars : [
		'command'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #'instance creation' }
LaunchpadSettingsFileOption class >> for: aCommand [

	^ self new initializeFor: aCommand
]

{ #category : #testing }
LaunchpadSettingsFileOption >> canHandle: argument [

	^ argument beginsWith: '--' , self name , '='
]

{ #category : #evaluating }
LaunchpadSettingsFileOption >> evaluateWithin: context handling: argument [

	| fileName |

	fileName := argument withoutFirst: self name size + 3.

	command addConfigurationProviderFromFile: fileName asFileReference
]

{ #category : #initialization }
LaunchpadSettingsFileOption >> initializeFor: aCommand [

	command := aCommand
]

{ #category : #accessing }
LaunchpadSettingsFileOption >> name [

	^ 'settings-file'
]

{ #category : #printing }
LaunchpadSettingsFileOption >> printHelpOn: stream [

	super printHelpOn: stream.
	self printSuffixOn: stream
]

{ #category : #printing }
LaunchpadSettingsFileOption >> printSuffixOn: stream [

	stream nextPutAll: '=<filename>'
]

{ #category : #accessing }
LaunchpadSettingsFileOption >> summary [

	^ 'Provide application configuration via a settings file. This option can occur several times to configure more than one settings file. Supported file settings formats are INI and JSON.'
]
