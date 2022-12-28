"
An OptionalConfigurationParameterTest is a test class for testing the behavior of OptionalConfigurationParameter
"
Class {
	#name : #OptionalConfigurationParameterTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #private }
OptionalConfigurationParameterTest >> set: environmentVariableName to: value during: aBlock [

	OSPlatform current environment at: environmentVariableName put: value.
	aBlock ensure: [ OSPlatform current environment removeKey: environmentVariableName ]
]

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
OptionalConfigurationParameterTest >> testBooleanTransformation [

	| parameter provider |

	parameter := OptionalConfigurationParameter
		             named: 'Use beta features'
		             describedBy: 'Determines if experimental stuff is ready'
		             defaultingTo: true
		             convertingWith: #asBoolean.

	provider := ConfigurationFromEnvironmentProvider new.

	self assert: ( self valueOfSetting: parameter whenSetTo: 'true' using: provider ).
	self deny: ( self valueOfSetting: parameter whenSetTo: 'false' using: provider ).
	self deny: ( self valueOfSetting: parameter whenSetTo: 'True' using: provider ).
	self deny: ( self valueOfSetting: parameter whenSetTo: 'TRUE' using: provider ).
	self deny: ( self valueOfSetting: parameter whenSetTo: '' using: provider )
]

{ #category : #tests }
OptionalConfigurationParameterTest >> testNumberTransformation [

	| parameter provider |

	parameter := OptionalConfigurationParameter
		             named: 'Port'
		             describedBy: 'The service''s listening port'
		             defaultingTo: 8080
		             convertingWith: #asNumber.

	provider := ConfigurationFromEnvironmentProvider new.

	self assert: ( self valueOfSetting: parameter whenSetTo: '1' using: provider ) equals: 1.
	self assert: ( self valueOfSetting: parameter whenSetTo: '01' using: provider ) equals: 1.
	self assert: ( self valueOfSetting: parameter whenSetTo: '11' using: provider ) equals: 11.

	self
		should: [ self valueOfSetting: parameter whenSetTo: 'a story about an API' using: provider ]
		raise: Error
		withMessageText: 'Reading a number failed: a digit between 0 and 9 expected'.

	self
		should: [ self valueOfSetting: parameter whenSetTo: '' using: provider ]
		raise: Error
		withMessageText: 'Reading a number failed: a digit between 0 and 9 expected'
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

{ #category : #tests }
OptionalConfigurationParameterTest >> testUrlTransformation [

	| parameter provider |

	parameter := OptionalConfigurationParameter
		             named: 'Location'
		             describedBy: 'Web site for the company'
		             defaultingTo: 'www.wecare.org'
		             convertingWith: #asUrl.

	provider := ConfigurationFromEnvironmentProvider new.

	self
		assert: ( self valueOfSetting: parameter whenSetTo: 'http://www.the-server.com' using: provider )
		equals: ( ZnUrl fromString: 'http://www.the-server.com' ).
	self
		assert: ( self valueOfSetting: parameter whenSetTo: '' using: provider )
		equals: ( ZnUrl fromString: '/' )
]

{ #category : #private }
OptionalConfigurationParameterTest >> valueOfSetting: aParameter whenSetTo: aString using: aProvider [

	| valueBinding |

	valueBinding := Binding undefinedExplainedBy: 'Not yed defined'.
	self
		set: aParameter environmentVariableName
		to: aString
		during: [ 
		valueBinding := Binding to: ( aParameter resolveValueUsing: aProvider ifUnable: [ self fail ] ) ].
	
	^ valueBinding content
]
