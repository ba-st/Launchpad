Class {
	#name : #BaselineOfApplicationStarter,
	#superclass : #BaselineOf,
	#category : #BaselineOfApplicationStarter
}

{ #category : #baselines }
BaselineOfApplicationStarter >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ spec
				package: 'Application-Starter';
				group: 'Deployment' with: 'Application-Starter'.
			spec
				package: 'Application-Starter-Examples' with: [ spec requires: 'Application-Starter' ];
				group: 'Examples' with: 'Application-Starter-Examples'.
			spec
				package: 'Application-Starter-Tests'
					with: [ spec requires: #('Application-Starter' 'Application-Starter-Examples') ];
				group: 'Development' with: 'Application-Starter-Tests'.
			spec
				group: 'Development' with: 'Deployment';
				group: 'default' with: 'Development'
			].
	self setUpCompatibilityPackages: spec
]

{ #category : #baselines }
BaselineOfApplicationStarter >> setUpCompatibilityPackages: spec [

	spec
		for: #'pharo6.x'
		do: [ spec
				package: 'Application-Starter-Pharo6';
				group: 'Deployment' with: 'Application-Starter-Pharo6'
			].
	spec
		for: #'pharo7.x'
		do: [ spec
				package: 'Application-Starter-Pharo7';
				group: 'Deployment' with: 'Application-Starter-Pharo7'
			]
]
