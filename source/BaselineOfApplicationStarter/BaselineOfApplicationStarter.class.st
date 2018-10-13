Class {
	#name : #BaselineOfApplicationStarter,
	#superclass : #BaselineOf,
	#category : #BaselineOfApplicationStarter
}

{ #category : #baselines }
BaselineOfApplicationStarter >> baseline: spec [

	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'Application-Starter';
				package: 'Application-Starter-Tests' with: [ spec requires: 'Application-Starter' ].
			spec
				group: 'Deployment' with: #('Application-Starter');
				group: 'Development' with: #('Application-Starter-Tests');
				group: 'default' with: #('Deployment') ]
]
