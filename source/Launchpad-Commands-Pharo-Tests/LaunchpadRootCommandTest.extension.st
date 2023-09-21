Extension { #name : #LaunchpadRootCommandTest }

{ #category : #'*Launchpad-Commands-Pharo-Tests' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationEnablingTCPCommandServer [

	| output |

	output := self handle: { 
			          'launchpad'.
			          'start'.
			          '--debug-mode'.
			          '--enable-tcp-command-server=0'.
			          LaunchpadGreeterApplication commandName.
			          '--name=John' }.

	self assert: output equals: 'Hi John!<n>' expandMacros.

	self assertLogRecordsMatch: #( 
		'[INFO] Receiving commands over TCP/0'
		'[INFO] greeter [v1.0.0] - A greetings application'
		'[INFO] Obtaining configuration...'
		'[WARNING] "Title" parameter not provided. Using default.'
		'[INFO] Name: John'
		'[INFO] Title: '
		'[INFO] Obtaining configuration... [DONE]'
		'[INFO] Exit application' )
]
