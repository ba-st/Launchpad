"
A MandatoryConfigurationParameterTest is a test class for testing the behavior of MandatoryConfigurationParameter
"
Class {
	#name : #MandatoryConfigurationParameterTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

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
		             inSection: 'Stargate'.

	self
		assert: parameter name equals: 'Public URL';
		assert: parameter summary equals: 'The service''s public URL';
		assert: parameter commandLineArgumentName equals: 'stargate.public-url';
		assert: parameter environmentVariableName equals: 'STARGATE__PUBLIC_URL';
		assert: parameter attributeName equals: 'publicURL'
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
