Class {
	#name : #LaunchpadOption,
	#superclass : #Object,
	#category : #'Launchpad-Commands'
}

{ #category : #testing }
LaunchpadOption >> canHandle: argument [

	^ argument = ( '--' , self name )
]

{ #category : #evaluating }
LaunchpadOption >> evaluateWithin: context handling: argument [

	self subclassResponsibility
]

{ #category : #accessing }
LaunchpadOption >> name [

	^ self subclassResponsibility
]

{ #category : #printing }
LaunchpadOption >> printAsCommandLineArgumentTemplateOn: stream [

	stream
		nextPutAll: '[--';
		nextPutAll: self name.
	self printSuffixOn: stream.
	stream nextPut: $]
]

{ #category : #printing }
LaunchpadOption >> printHelpOn: stream [

	stream
		nextPutAll: '--';
		nextPutAll: self name
]

{ #category : #printing }
LaunchpadOption >> printSuffixOn: stream [

	
]

{ #category : #accessing }
LaunchpadOption >> summary [

	^ self subclassResponsibility
]
