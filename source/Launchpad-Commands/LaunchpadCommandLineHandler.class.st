Class {
	#name : #LaunchpadCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Launchpad-Commands'
}

{ #category : #accessing }
LaunchpadCommandLineHandler class >> commandName [

	^ LaunchpadMainCommand commandName
]

{ #category : #accessing }
LaunchpadCommandLineHandler class >> description [

	^ LaunchpadMainCommand summary
]

{ #category : #activation }
LaunchpadCommandLineHandler >> activate [

	| context |

	StandardStreamLogger onStandardOutput startFor:
		( LaunchpadLogRecord where: [ :record | record isInformational ] ).
	StandardStreamLogger onStandardError startFor:
		( LaunchpadLogRecord where: [ :record | record isInformational not ] ).

	context := LaunchpadCommandLineProcessingContext handling: commandLine writingTo: self stdout.
	context usePlatformLineEnding.
	LaunchpadMainCommand new evaluateWithin: context
]
