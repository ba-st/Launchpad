"
A ConfigurationFromCommandLineProviderTest is a test class for testing the behavior of ConfigurationFromCommandLineProvider
"
Class {
	#name : #ConfigurationFromCommandLineProviderTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #private }
ConfigurationFromCommandLineProviderTest >> providerOver: arguments [

	^ ConfigurationFromCommandLineProvider over: ( CommandLineArguments withArguments: arguments )
]

{ #category : #tests }
ConfigurationFromCommandLineProviderTest >> testMandatoryConfigurationParameterValue [

	| provider mandatoryParameter |

	mandatoryParameter := MandatoryConfigurationParameter named: 'Hostname'
		                      describedBy: 'Hostname to connect.'.

	provider := self providerOver: #( '--other=parameter' '--hostname=localhost' ).

	self assert: ( mandatoryParameter resolveValueUsing: provider ifUnresolvable: [ self fail ] )
		equals: 'localhost'
]

{ #category : #tests }
ConfigurationFromCommandLineProviderTest >> testMandatoryConfigurationParameterValueMissing [

	| provider mandatoryParameter |

	mandatoryParameter := MandatoryConfigurationParameter named: 'Hostname'
		                      describedBy: 'Hostname to connect.'.

	provider := self providerOver: #(  ).

	self assert: ( mandatoryParameter resolveValueUsing: provider ifUnresolvable: [ 'example.com' ] )
		equals: 'example.com'
]

{ #category : #tests }
ConfigurationFromCommandLineProviderTest >> testOptionalConfigurationParameterValue [

	| provider parameter |

	parameter := OptionalConfigurationParameter named: 'Hostname'
		             describedBy: 'Hostname to connect.'
		             defaultingTo: 'localhost'.

	provider := self providerOver: #( '--hostname=https://example.com' ).

	self assert: ( parameter resolveValueUsing: provider ifUnresolvable: [ self fail ] )
		equals: 'https://example.com'
]

{ #category : #tests }
ConfigurationFromCommandLineProviderTest >> testOptionalConfigurationParameterValueUsingDefault [

	| provider parameter |

	parameter := OptionalConfigurationParameter named: 'Hostname'
		             describedBy: 'Hostname to connect.'
		             defaultingTo: 'localhost'.

	provider := self providerOver: #(  ).

	self assert: ( parameter resolveValueUsing: provider ifUnresolvable: [ self fail ] )
		equals: 'localhost'
]

{ #category : #tests }
ConfigurationFromCommandLineProviderTest >> testSensitiveMandatoryConfigurationParameterValue [

	| provider mandatoryParameter |

	mandatoryParameter := ( MandatoryConfigurationParameter named: 'Hostname'
		                        describedBy: 'Hostname to connect.' ) asSensitive.

	provider := self providerOver: #( '--hostname=localhost' ).

	self assert: ( mandatoryParameter resolveValueUsing: provider ifUnresolvable: [ self fail ] )
		equals: 'localhost'
]

{ #category : #tests }
ConfigurationFromCommandLineProviderTest >> testSensitiveOptionalConfigurationParameterValue [

	| provider parameter |

	parameter := ( OptionalConfigurationParameter named: 'Hostname'
		               describedBy: 'Hostname to connect.'
		               defaultingTo: 'localhost' ) asSensitive.

	provider := self providerOver: #(  ).

	self assert: ( parameter resolveValueUsing: provider ifUnresolvable: [ self fail ] )
		equals: 'localhost'
]
