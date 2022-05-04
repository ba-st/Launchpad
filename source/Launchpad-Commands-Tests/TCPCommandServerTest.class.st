"
A TCPCommandServerTest is a test class for testing the behavior of TCPCommandServer
"
Class {
	#name : #TCPCommandServerTest,
	#superclass : #TestCase,
	#instVars : [
		'server'
	],
	#category : #'Launchpad-Commands-Tests'
}

{ #category : #running }
TCPCommandServerTest >> setUp [

	super setUp.
	server := TCPCommandServer listeningOn: self freeListeningTCPPort
]

{ #category : #running }
TCPCommandServerTest >> tearDown [

	server ifNotNil: #stop.
	super tearDown
]

{ #category : #tests }
TCPCommandServerTest >> testCommandEvaluation [

	| wasEvaluated semaphore |

	wasEvaluated := false.
	semaphore := Semaphore new.
	server
		registerCommandNamed: 'SHUTDOWN' executing: [ 
			wasEvaluated := true.
			semaphore signal
			];
		start.

	self deny: wasEvaluated.

	self
		withClientSocketConnectingTo: server listeningPort
		do: [ :clientSocket | clientSocket sendData: 'SHUTDOWN' ].

	semaphore wait.
	self assert: wasEvaluated
]

{ #category : #tests }
TCPCommandServerTest >> testUnknownCommandEvaluation [

	| semaphore |

	semaphore := Semaphore new.
	server
		registerCommandNamed: 'SHUTDOWN' executing: [ semaphore signal ];
		start.

	self
		withClientSocketConnectingTo: server listeningPort
		do: [ :clientSocket | clientSocket sendData: 'XXX' ].

	self
		withClientSocketConnectingTo: server listeningPort
		do: [ :clientSocket | clientSocket sendData: 'SHUTDOWN' ].

	semaphore wait
]

{ #category : #private }
TCPCommandServerTest >> withClientSocketConnectingTo: port do: aBlock [

	| clientSocket |

	clientSocket := Socket newTCP.
	clientSocket
		connectTo: NetNameResolver loopBackAddress port: port;
		waitForConnectionFor: 10.
	self assert: clientSocket isConnected.
	[ aBlock value: clientSocket ] ensure: [ clientSocket closeAndDestroy ]
]
