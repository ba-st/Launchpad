"
A SensitiveConfigurationParameterTest is a test class for testing the behavior of SensitiveConfigurationParameter
"
Class {
	#name : #SensitiveConfigurationParameterTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #tests }
SensitiveConfigurationParameterTest >> testAccessing [

	| parameter |

	parameter := ( MandatoryConfigurationParameter named: 'Public URL'
		               describedBy: 'The service''s public URL' ) asSensitive.

	self
		assert: parameter name equals: 'Public URL';
		assert: parameter summary equals: 'The service''s public URL';
		assert: parameter commandLineArgumentName equals: 'public-url';
		assert: parameter environmentVariableName equals: 'PUBLIC_URL';
		assert: parameter attributeName equals: 'publicURL'
]

{ #category : #tests }
SensitiveConfigurationParameterTest >> testPrintAsCommandLineArgumentTemplate [

	| parameter |

	parameter := ( MandatoryConfigurationParameter named: 'Public URL'
		               describedBy: 'The service''s public URL' ) asSensitive.

	self assert:
		( String streamContents: [ :stream | parameter printAsCommandLineArgumentTemplateOn: stream ] )
		equals: '--public-url=<publicURL>'
]

{ #category : #tests }
SensitiveConfigurationParameterTest >> testPrintString [

	| parameter |

	parameter := ( MandatoryConfigurationParameter named: 'Public URL'
		               describedBy: 'The service''s public URL' ) asSensitive.

	self assert: parameter printString equals: '--public-url
	[Mandatory] The service''s public URL.'.

	parameter := ( MandatoryConfigurationParameter named: 'Public URL'
		               describedBy: 'The service''s public URL'
		               inside: #( 'Application' 'Targets' ) ) asSensitive.

	self assert: parameter printString equals: '--application.targets.public-url
	[Mandatory] The service''s public URL.'
]
