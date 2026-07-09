"
Small example Zinc server application to demonstrate Launchpad with tiny web server example
"
Class {
	#name : 'LaunchpadZnHelloApplication',
	#superclass : 'LaunchpadApplication',
	#category : 'Launchpad-Examples',
	#package : 'Launchpad-Examples'
}

{ #category : 'accessing' }
LaunchpadZnHelloApplication class >> commandName [

	^ 'znHello'
]

{ #category : 'private - accessing' }
LaunchpadZnHelloApplication class >> configurationParameters [

	^ {
		  (OptionalConfigurationParameter
			   named: #'log-level'
			   describedBy: 'Log http requests level'
			   defaultingTo: 0).

		  (OptionalConfigurationParameter
			   named: #port
			   describedBy: 'Server port'
			   defaultingTo: 8181) }
]

{ #category : 'accessing' }
LaunchpadZnHelloApplication class >> description [

	^ 'Launchpad demo zinc http application'
]

{ #category : 'example' }
LaunchpadZnHelloApplication class >> startServer [
	<script>
	"This would really be in its own server class, but here to demonstrate a simple example of a running application to start via the command line.
	eg using: launchpad start ZnHello --log-level=2"

	self startServerOn: 8181 debug: true
]

{ #category : 'example' }
LaunchpadZnHelloApplication class >> startServerOn: port debug: debug [ 
	"This would really be in its own server class, but here to demonstrate a simple example"

	| server |
	server := (ZnServer defaultOn: port).
	debug ifTrue: [ server logToTranscript ].
	server start.
]

{ #category : 'example' }
LaunchpadZnHelloApplication class >> stopServer [
	<script>
	"This would really be in its own server class, but here to demonstrate a simple example"

	ZnServer default stop
]

{ #category : 'accessing' }
LaunchpadZnHelloApplication class >> version [

	^ 'v1.0.0'
]

{ #category : 'private - activation' }
LaunchpadZnHelloApplication >> basicStartWithin: context [
	"This is an example of a launcher using a testable #run:withArguments: pattern. See the example test "

	| debugLevel serverPort |
	
	debugLevel := [(self configuration valueAt: #'log-level') asNumber] on: Error do: [ 0 ].
	serverPort := (self configuration valueAt: #port) asInteger.

	"This would be something to call for your own application class to allow testing"
	context runZnHelloWithPort: serverPort debugLevel: debugLevel
]

{ #category : 'accessing' }
LaunchpadZnHelloApplication >> name [

	^ self configuration name
]

{ #category : 'error handling' }
LaunchpadZnHelloApplication >> stackTraceDumper [

	^ NullStackTraceDumper new
]

{ #category : 'accessing' }
LaunchpadZnHelloApplication >> title [

	^ self configuration title
]
