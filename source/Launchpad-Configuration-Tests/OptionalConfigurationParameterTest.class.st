"
An OptionalConfigurationParameterTest is a test class for testing the behavior of OptionalConfigurationParameter
"
Class {
	#name : #OptionalConfigurationParameterTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #tests }
OptionalConfigurationParameterTest >> testAccessing [

	| parameter |

	parameter := OptionalConfigurationParameter named: 'Port'
		             describedBy: 'The service''s listening port'
		             defaultingTo: 8080.

	self
		assert: parameter name equals: 'Port';
		assert: parameter summary equals: 'The service''s listening port. Defaults to 8080';
		assert: parameter commandLineArgumentName equals: 'port';
		assert: parameter environmentVariableName equals: 'PORT';
		assert: parameter attributeName equals: 'port'
]

{ #category : #tests }
OptionalConfigurationParameterTest >> testAccessingInInnerSection [

	| parameter |

	parameter := OptionalConfigurationParameter named: 'Port'
		             describedBy: 'The service''s listening port'
		             inside: #( 'Communications' 'HTTP' )
		             defaultingTo: 8080.

	self
		assert: parameter name equals: 'Port';
		assert: parameter summary equals: 'The service''s listening port. Defaults to 8080';
		assert: parameter commandLineArgumentName equals: 'communications.http.port';
		assert: parameter environmentVariableName equals: 'COMMUNICATIONS__HTTP__PORT';
		assert: parameter attributeName equals: 'port'
]

{ #category : #tests }
OptionalConfigurationParameterTest >> testAccessingInSection [

	| parameter |

	parameter := OptionalConfigurationParameter named: 'Port'
		             describedBy: 'The service''s listening port'
		             inside: #( 'HTTP' )
		             defaultingTo: 8080.

	self
		assert: parameter name equals: 'Port';
		assert: parameter summary equals: 'The service''s listening port. Defaults to 8080';
		assert: parameter commandLineArgumentName equals: 'http.port';
		assert: parameter environmentVariableName equals: 'HTTP__PORT';
		assert: parameter attributeName equals: 'port'
]

{ #category : #tests }
OptionalConfigurationParameterTest >> testPrintString [

	| parameter |

	parameter := OptionalConfigurationParameter named: 'Port'
		             describedBy: 'The service''s listening port'
		             defaultingTo: 8080.

	self assert: parameter printString equals: '--port
	[Optional] The service''s listening port. Defaults to 8080.'.

	parameter := OptionalConfigurationParameter named: 'Port'
		             describedBy: 'The service''s listening port'
		             inside: #( 'Communications' 'HTTP' )
		             defaultingTo: 8080.

	self assert: parameter printString equals: '--communications.http.port
	[Optional] The service''s listening port. Defaults to 8080.'
]
