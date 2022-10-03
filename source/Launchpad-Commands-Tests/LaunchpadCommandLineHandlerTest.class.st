"
A LaunchpadCommandLineHandlerTest is a test class for testing the behavior of LaunchpadCommandLineHandler
"
Class {
	#name : #LaunchpadCommandLineHandlerTest,
	#superclass : #LaunchpadTest,
	#category : #'Launchpad-Commands-Tests'
}

{ #category : #tests }
LaunchpadCommandLineHandlerTest >> testDescription [

	self assert: LaunchpadCommandLineHandler description
		equals: 'A minimal application launcher'
]

{ #category : #tests }
LaunchpadCommandLineHandlerTest >> testHandlingHelpOption [

	| commandLine |

	commandLine := CommandLineArguments withArguments: #( 'launchpad' '--help' ).

	self should: [ LaunchpadCommandLineHandler activateWith: commandLine ]
		raise: Exit
		withExceptionDo: [ :exit | self assert: exit isSuccess ]
]

{ #category : #tests }
LaunchpadCommandLineHandlerTest >> testStartingApplication [

	| commandLine |

	commandLine := CommandLineArguments withArguments: #( 'launchpad' 'start' 'greeter' '--name=John' ).

	self
		should: [ LaunchpadCommandLineHandler activateWith: commandLine ]
		raise: Exit
		withExceptionDo: [ :exit | self assert: exit isSuccess ].

	self
		should: [ self start: LaunchpadGreeterApplication withAll: #(  ) ]
		raise: RequiredConfigurationNotFound
]
