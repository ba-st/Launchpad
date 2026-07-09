"
A LaunchpadCommandLineHandlerTest is a test class for testing the behavior of LaunchpadCommandLineHandler
"
Class {
	#name : 'LaunchpadZnHelloApplicationTest',
	#superclass : 'LaunchpadTest',
	#category : 'Launchpad-Commands-Tests',
	#package : 'Launchpad-Commands-Tests'
}

{ #category : 'tests' }
LaunchpadZnHelloApplicationTest >> testConfigParsingInValidLogLevel [
	"Verify the launchpad handler properly handles non numeric input"
	
	| application mockContext config |
	
	"Test passing a non-numeric log level parameter"
	config := NullConfigurationProvider new
		          atName: #'log-level' putValue: 'false';
		          yourself.

	application := LaunchpadZnHelloApplication 
		               runningIn: DebuggingApplicationMode new
		               configuredBy: config
		               controlledBy: NullCommandServer new.

	"Expect the Launchpad application to handle the error and substitute a loglevel of 0"
	mockContext := MockObject new
		               on: #runZnHelloWithPort:debugLevel: 
		               with: 8181
							with: 0;
		               yourself.

	application basicStartWithin: mockContext.

	mockContext verifyIn: self
]

{ #category : 'tests' }
LaunchpadZnHelloApplicationTest >> testConfigParsingValidLogLevel [
	"Verify the launchpad handler correctly parses the paramter to an integer"

	| application mockContext config |
	
	config := NullConfigurationProvider new
		          atName: #'log-level' putValue: '2';
		          yourself.

	application := LaunchpadZnHelloApplication 
		               runningIn: DebuggingApplicationMode new
		               configuredBy: config
		               controlledBy: NullCommandServer new.

	mockContext := MockObject new
		               on: #runZnHelloWithPort:debugLevel: 
		               with: 8181
							with: 2;
		               yourself.

	application basicStartWithin: mockContext.

	mockContext verifyIn: self
]

{ #category : 'tests' }
LaunchpadZnHelloApplicationTest >> testDryRunApplication [

	self
		should: [
			LaunchpadCommandLineHandler activateWithArguments:
				#( 'launchpad' 'start' '--dry-run' 'znHello' )
			]
		raise: Exit
		withExceptionDo: [ :exit | self assert: exit isSuccess ] 

]
