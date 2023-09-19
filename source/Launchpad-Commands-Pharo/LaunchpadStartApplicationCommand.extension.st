Extension { #name : #LaunchpadStartApplicationCommand }

{ #category : #'*Launchpad-Commands-Pharo' }
LaunchpadStartApplicationCommand >> enableTCPCommandServerListeningOn: listeningPort [

	commandServer := TCPCommandServer listeningOn: listeningPort.
	commandServer registerCommandNamed: 'SHUTDOWN' executing: [ 
		[ 
		LaunchpadApplication currentlyRunning
			stop;
			exitSuccess
		] forkAt: Processor timingPriority named: 'Launchpad shutdown process'
		]
]
