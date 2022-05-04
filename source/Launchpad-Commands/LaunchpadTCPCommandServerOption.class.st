Class {
	#name : #LaunchpadTCPCommandServerOption,
	#superclass : #LaunchpadOption,
	#instVars : [
		'command'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #'instance creation' }
LaunchpadTCPCommandServerOption class >> for: aCommand [

	^ self new initializeFor: aCommand
]

{ #category : #testing }
LaunchpadTCPCommandServerOption >> canHandle: argument [

	^ argument beginsWith: '--' , self name , '='
]

{ #category : #evaluating }
LaunchpadTCPCommandServerOption >> evaluateWithin: context handling: argument [

	| listeningPort |

	listeningPort := ( argument withoutFirst: self name size + 3 ) asNumber.
	command enableTCPCommandServerListeningOn: listeningPort
]

{ #category : #initialization }
LaunchpadTCPCommandServerOption >> initializeFor: aCommand [

	command := aCommand
]

{ #category : #accessing }
LaunchpadTCPCommandServerOption >> name [

	^ 'enable-tcp-command-server'
]

{ #category : #printing }
LaunchpadTCPCommandServerOption >> printHelpOn: stream [

	super printHelpOn: stream.
	self printSuffixOn: stream
]

{ #category : #printing }
LaunchpadTCPCommandServerOption >> printSuffixOn: stream [

	stream nextPutAll: '=<listeningPort>'
]

{ #category : #accessing }
LaunchpadTCPCommandServerOption >> summary [

	^ 'Enable a TCP command server. This can be used to send commands controlling the application using a TCP port.'
]
