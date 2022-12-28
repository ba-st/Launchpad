"
A MandatoryConfigurationParameterTest is a test class for testing the behavior of MandatoryConfigurationParameter
"
Class {
	#name : #MandatoryConfigurationParameterTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #private }
MandatoryConfigurationParameterTest >> set: environmentVariableName to: value during: aBlock [

	OSPlatform current environment at: environmentVariableName put: value.
	aBlock ensure: [ OSPlatform current environment removeKey: environmentVariableName ]
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

	| parameter provider |

	parameter := MandatoryConfigurationParameter
		             named: 'Be public'
		             describedBy: 'Whether it will be visible'
		             convertingWith: #asBoolean.

	provider := ConfigurationFromEnvironmentProvider new.

	self assert: ( self valueOfSetting: parameter whenSetTo: 'true' using: provider ).
	self deny: ( self valueOfSetting: parameter whenSetTo: 'false' using: provider ).
	self deny: ( self valueOfSetting: parameter whenSetTo: 'True' using: provider ).
	self deny: ( self valueOfSetting: parameter whenSetTo: 'TRUE' using: provider ).
	self deny: ( self valueOfSetting: parameter whenSetTo: '' using: provider )
]

{ #category : #tests }
MandatoryConfigurationParameterTest >> testNumberTransformation [

	| parameter provider |

	parameter := MandatoryConfigurationParameter
		             named: 'Port'
		             describedBy: 'The number of the port to listen'
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

	| parameter provider |

	parameter := MandatoryConfigurationParameter
		             named: 'Url'
		             describedBy: 'The base URL'
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
MandatoryConfigurationParameterTest >> valueOfSetting: aParameter whenSetTo: aString using: aProvider [

	| valueBinding |

	valueBinding := Binding undefinedExplainedBy: 'Not yed defined'.
	self
		set: aParameter environmentVariableName
		to: aString
		during: [ 
		valueBinding := Binding to: ( aParameter resolveValueUsing: aProvider ifUnable: [ self fail ] ) ].
	
	^ valueBinding content
]
