"
A LaunchpadApplicationTest is a test class for testing the behavior of LaunchpadApplication
"
Class {
	#name : #LaunchpadApplicationTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Applications-Tests'
}

{ #category : #test }
LaunchpadApplicationTest >> testIsDebugModeEnabled [

	| application |

	application := LaunchpadBrokenApplication
		               runningIn: DebuggingApplicationMode new
		               configuredBy: NullConfigurationProvider new
		               controlledBy: NullCommandServer new.
	self assert: application isDebugModeEnabled
]

{ #category : #test }
LaunchpadApplicationTest >> testIsDebugModeNotEnabled [

	| application |

	application := LaunchpadBrokenApplication
		               runningIn: ReleasedApplicationMode new
		               configuredBy: NullConfigurationProvider new
		               controlledBy: NullCommandServer new.
	self deny: application isDebugModeEnabled
]
