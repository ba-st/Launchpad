Class {
	#name : #LaunchpadShortOption,
	#superclass : #LaunchpadOption,
	#category : #'Launchpad-Commands'
}

{ #category : #testing }
LaunchpadShortOption class >> isAbstract [

	<ignoreForCoverage>
	^ self = LaunchpadShortOption
]

{ #category : #testing }
LaunchpadShortOption >> canHandle: argument [

	^ ( super canHandle: argument ) or: [ argument = ( '-' , self shortName ) ]
]

{ #category : #printing }
LaunchpadShortOption >> printHelpOn: stream [

	stream
		nextPut: $-;
		nextPutAll: self shortName;
		nextPutAll: ',';
		space.
	super printHelpOn: stream
]

{ #category : #printing }
LaunchpadShortOption >> printSuffixOn: stream [

	stream
		nextPutAll: '|-';
		nextPutAll: self shortName
]

{ #category : #accessing }
LaunchpadShortOption >> shortName [

	^ self subclassResponsibility
]
