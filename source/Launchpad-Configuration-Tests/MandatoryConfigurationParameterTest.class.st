"
A MandatoryConfigurationParameterTest is a test class for testing the behavior of MandatoryConfigurationParameter
"
Class {
	#name : #MandatoryConfigurationParameterTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #private }
MandatoryConfigurationParameterTest >> commandLineProviderSetting: aParameter to: aString [

	^ ConfigurationFromCommandLineProvider over: ( CommandLineArguments withArguments:
			    ( Array with: ( '--<1s>=<2s>' expandMacrosWith: aParameter name with: aString ) ) )
]

{ #category : #tests }
MandatoryConfigurationParameterTest >> testAccessing [

	| parameter |

	parameter := MandatoryConfigurationParameter named: 'Public URL'
		             describedBy: 'The service''s public URL'.

	self
		assert: parameter name equals: 'Public URL';
		assert: parameter summary equals: 'The service''s public URL';
		assert: parameter commandLineArgumentName equals: 'public-url';
		assert: parameter environmentVariableName equals: 'PUBLIC_URL';
		assert: parameter attributeName equals: 'publicURL'
]

{ #category : #tests }
MandatoryConfigurationParameterTest >> testAccessingInInnerSection [

	| parameter |

	parameter := MandatoryConfigurationParameter named: 'Public URL'
		             describedBy: 'The service''s public URL'
		             inside: #( 'Stargate' 'URIs' ).

	self
		assert: parameter name equals: 'Public URL';
		assert: parameter summary equals: 'The service''s public URL';
		assert: parameter commandLineArgumentName equals: 'stargate.uris.public-url';
		assert: parameter environmentVariableName equals: 'STARGATE__URIS__PUBLIC_URL';
		assert: parameter attributeName equals: 'publicURL'
]

{ #category : #tests }
MandatoryConfigurationParameterTest >> testAccessingInSection [

	| parameter |

	parameter := MandatoryConfigurationParameter named: 'Public URL'
		             describedBy: 'The service''s public URL'
		             inside: #( 'Stargate' ).

	self
		assert: parameter name equals: 'Public URL';
		assert: parameter summary equals: 'The service''s public URL';
		assert: parameter commandLineArgumentName equals: 'stargate.public-url';
		assert: parameter environmentVariableName equals: 'STARGATE__PUBLIC_URL';
		assert: parameter attributeName equals: 'publicURL'
]

{ #category : #tests }
MandatoryConfigurationParameterTest >> testBooleanTransformation [

	| parameter |

	parameter := MandatoryConfigurationParameter
		             named: 'public'
		             describedBy: 'Whether it will be visible'
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
MandatoryConfigurationParameterTest >> testNumberTransformation [

	| parameter |

	parameter := MandatoryConfigurationParameter
		             named: 'port'
		             describedBy: 'The number of the port to listen'
		             convertingWith: #asNumber.

	self assert: ( self valueWhenSetting: parameter to: '1' ) equals: 1.
	self assert: ( self valueWhenSetting: parameter to: '01' ) equals: 1.
	self assert: ( self valueWhenSetting: parameter to: '11' ) equals: 11.

	self
		should: [ self valueWhenSetting: parameter to: 'a story about an API' ]
		raise: Error
		withMessageText: 'Reading a number failed: a digit between 0 and 9 expected'.

	self
		should: [ self valueWhenSetting: parameter to: '' ]
		raise: Error
		withMessageText: 'Reading a number failed: a digit between 0 and 9 expected'
]

{ #category : #tests }
MandatoryConfigurationParameterTest >> testPrintString [

	| parameter |

	parameter := MandatoryConfigurationParameter named: 'Public URL'
		             describedBy: 'The service''s public URL'.

	self assert: parameter printString equals: '--public-url
	[Mandatory] The service''s public URL.'.

	parameter := MandatoryConfigurationParameter named: 'Public URL'
		             describedBy: 'The service''s public URL'
		             inside: #( 'Application' 'Targets' ).

	self assert: parameter printString equals: '--application.targets.public-url
	[Mandatory] The service''s public URL.'
]

{ #category : #tests }
MandatoryConfigurationParameterTest >> testUrlTransformation [

	| parameter |

	parameter := MandatoryConfigurationParameter
		             named: 'url'
		             describedBy: 'The base URL'
		             convertingWith: #asUrl.

	self
		assert: ( self valueWhenSetting: parameter to: 'http://www.the-server.com' )
		equals: ( ZnUrl fromString: 'http://www.the-server.com' ).
	self assert: ( self valueWhenSetting: parameter to: '' ) equals: ( ZnUrl fromString: '/' )
]

{ #category : #private }
MandatoryConfigurationParameterTest >> valueWhenSetting: aParameter to: aString [

	| provider |

	provider := self commandLineProviderSetting: aParameter to: aString.

	^ aParameter resolveValueUsing: provider ifUnable: [ self fail ]
]
