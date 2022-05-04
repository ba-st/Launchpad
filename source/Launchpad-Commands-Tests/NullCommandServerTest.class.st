"
A NullCommandServerTest is a test class for testing the behavior of NullCommandServer
"
Class {
	#name : #NullCommandServerTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Commands-Tests'
}

{ #category : #tests }
NullCommandServerTest >> testStop [

	NullCommandServer new
		start;
		stop
]
