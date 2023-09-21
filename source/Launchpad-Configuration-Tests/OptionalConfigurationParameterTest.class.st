"
An OptionalConfigurationParameterTest is a test class for testing the behavior of OptionalConfigurationParameter
"
Class {
	#name : #OptionalConfigurationParameterTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #private }
OptionalConfigurationParameterTest >> commandLineProviderSetting: aParameter to: aString [

	^ ConfigurationFromCommandLineProvider over: ( CommandLineArguments withArguments:
			    ( Array with:
				      ( '--<1s>=<2s>' expandMacrosWith: aParameter commandLineArgumentName with: aString ) ) )
]

{ #category : #private }
OptionalConfigurationParameterTest >> numberConversionAction [

	^ [ :value |
	  AssertionChecker
		  enforce: [ value isAllDigits ]
		  because: 'Expected a number'.
	  value asNumber ]
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

	| parameter |

	parameter := OptionalConfigurationParameter
		             named: 'beta'
		             describedBy: 'Determines if experimental stuff is ready'
		             defaultingTo: true
		             convertingWith: #asBoolean.

	self assert: ( self valueWhenSetting: parameter to: 'true' ).
	self assert: ( self valueWhenSetting: parameter to: 'trUE' ).
	self deny: ( self valueWhenSetting: parameter to: 'false' ).
	self deny: ( self valueWhenSetting: parameter to: 'fAlse' ).

	self
		should: [ self valueWhenSetting: parameter to: '' ]
		raise: Error
		withMessageText: ' can''t be interpreted as a boolean'.

	self
		should: [ self valueWhenSetting: parameter to: 'unclear' ]
		raise: Error
		withMessageText: 'unclear can''t be interpreted as a boolean'
]

{ #category : #tests }
OptionalConfigurationParameterTest >> testNumberTransformation [

	| parameter |

	parameter := OptionalConfigurationParameter
		             named: 'port'
		             describedBy: 'The service''s listening port'
		             defaultingTo: 8080
		             convertingWith: self numberConversionAction.

	self assert: ( self valueWhenSetting: parameter to: '1' ) equals: 1.
	self assert: ( self valueWhenSetting: parameter to: '01' ) equals: 1.
	self assert: ( self valueWhenSetting: parameter to: '11' ) equals: 11.

	self
		should: [ self valueWhenSetting: parameter to: 'a story about an API' ]
		raise: Error
		withMessageText: 'Expected a number'.

	self
		should: [ self valueWhenSetting: parameter to: '' ]
		raise: Error
		withMessageText: 'Expected a number'
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

	| parameter |

	parameter := OptionalConfigurationParameter
		             named: 'location'
		             describedBy: 'Web site for the company'
		             defaultingTo: 'www.wecare.org'
		             convertingWith: #asUrl.

	self
		assert: ( self valueWhenSetting: parameter to: 'http://www.the-server.com' )
		equals: ( ZnUrl fromString: 'http://www.the-server.com' ).
	self assert: ( self valueWhenSetting: parameter to: '' ) equals: ( ZnUrl fromString: '/' )
]

{ #category : #private }
OptionalConfigurationParameterTest >> valueWhenSetting: aParameter to: aString [

	| provider |

	provider := self commandLineProviderSetting: aParameter to: aString.

	^ aParameter resolveValueUsing: provider ifUnable: [ self fail ]
]
