Class {
	#name : #LaunchpadCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Launchpad-Commands'
}

{ #category : #accessing }
LaunchpadCommandLineHandler class >> commandName [

	^ LaunchpadRootCommand commandName
]

{ #category : #accessing }
LaunchpadCommandLineHandler class >> description [

	^ LaunchpadRootCommand summary
]

{ #category : #activation }
LaunchpadCommandLineHandler >> activate [

	| context |

	Processor activeProcess name: 'Launchpad CLI'.

	StandardStreamLogger onStandardOutput startFor:
		( LogRecord where: [ :record | record isInformational ] ).
	StandardStreamLogger onStandardError startFor:
		( LogRecord where: [ :record | record isInformational not ] ).

	context := LaunchpadCommandLineProcessingContext handling: commandLine writingTo: self stdout.
	context usePlatformLineEnding.
	LaunchpadRootCommand new evaluateWithin: context
]
