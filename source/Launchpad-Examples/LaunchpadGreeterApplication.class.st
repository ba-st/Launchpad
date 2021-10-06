Class {
	#name : #LaunchpadGreeterApplication,
	#superclass : #LaunchpadApplication,
	#category : #'Launchpad-Examples'
}

{ #category : #accessing }
LaunchpadGreeterApplication class >> commandName [

	^ 'greeter'
]

{ #category : #'private - accessing' }
LaunchpadGreeterApplication class >> configurationParameters [

	^ Array with:
		  ( MandatoryConfigurationParameter named: 'Name' describedBy: 'The name of the user to greet' )
		  with: ( OptionalConfigurationParameter named: 'Title'
				    describedBy: 'The title of the user to greet'
				    defaultingTo: '' )
]

{ #category : #accessing }
LaunchpadGreeterApplication class >> description [

	^ 'A greetings application'
]

{ #category : #accessing }
LaunchpadGreeterApplication class >> version [

	^ 'v1.0.0'
]

{ #category : #'private - activation' }
LaunchpadGreeterApplication >> basicStartWithin: context [

	context outputStreamDo: [ :stream | 
		stream
			nextPutAll:
				( 'Hi <1s><2?: ><3s>!' expandMacrosWith: self title with: self title isEmpty with: self name );
			cr
		].
	mode exitSuccess
]

{ #category : #accessing }
LaunchpadGreeterApplication >> name [

	^ self configuration name
]

{ #category : #'error handling' }
LaunchpadGreeterApplication >> stackTraceDumper [

	^ NullStackTraceDumper new
]

{ #category : #accessing }
LaunchpadGreeterApplication >> title [

	^ self configuration title
]
