"
A CurrentApplicationConfigurationTest is a test class for testing the behavior of CurrentApplicationConfiguration
"
Class {
	#name : 'CurrentApplicationConfigurationTest',
	#superclass : 'TestCase',
	#category : 'Launchpad-Applications-Tests',
	#package : 'Launchpad-Applications-Tests'
}

{ #category : 'tests' }
CurrentApplicationConfigurationTest >> testAccessingConfigurationOfRunningApplication [

	| application |

	application := LaunchpadBrokenApplication
		               runningIn: DebuggingApplicationMode new
		               configuredBy: NullConfigurationProvider new
		               controlledBy: NullCommandServer new.

	LaunchpadApplication
		setAsCurrentlyRunning: application
		during: [ self assert: CurrentApplicationConfiguration value equals: application configuration ]
]

{ #category : 'tests' }
CurrentApplicationConfigurationTest >> testNoApplicationRunning [

	self should: [ CurrentApplicationConfiguration value ]
		raise: AssertionFailed
		withMessageText: 'There''s no current application running.'
]
