Class {
	#name : #TCPCommandServer,
	#superclass : #CommandServer,
	#instVars : [
		'listeningPort',
		'commmands',
		'connectionSocket',
		'serverProcess'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #'instance creation' }
TCPCommandServer class >> listeningOn: port [

	^ self new initializeListeningOn: port
]

{ #category : #private }
TCPCommandServer >> initializeConnectionSocket [

	connectionSocket := Socket newTCP
]

{ #category : #initialize }
TCPCommandServer >> initializeListeningOn: port [

	listeningPort := port.
	commmands := Dictionary new.
	self initializeConnectionSocket
]

{ #category : #accessing }
TCPCommandServer >> listeningPort [

	^ listeningPort
]

{ #category : #registering }
TCPCommandServer >> registerCommandNamed: commandName executing: aBlock [

	commmands at: commandName put: aBlock
]

{ #category : #private }
TCPCommandServer >> serverLoop [

	^ [ 
	  ( connectionSocket waitForAcceptFor: 60 ) ifNotNil: [ :socket | 
		  [ 
		  | command |

		  command := socket receiveData trimBoth.
		  commmands at: command ifPresent: [ :action | action value ]
		  ] ensure: [ socket closeAndDestroy ]
		  ]
	  ] repeat
]

{ #category : #controlling }
TCPCommandServer >> start [

	LogRecord emitInfo:
		( 'Receiving commands over TCP/<1p>' expandMacrosWith: self listeningPort ).

	connectionSocket
		listenOn: self listeningPort
		backlogSize: 2
		interface: NetNameResolver loopBackAddress.

	serverProcess := [ self serverLoop ] newProcess.
	serverProcess priority: Processor userInterruptPriority.
	serverProcess name: 'Launchpad TPC Command Server'.
	serverProcess resume
]

{ #category : #controlling }
TCPCommandServer >> stop [

	serverProcess ifNotNil: #terminate.
	serverProcess := nil.
	connectionSocket closeAndDestroy.
	self initializeConnectionSocket
]
