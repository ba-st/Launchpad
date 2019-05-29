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
				group: 'Core' with: 'Application-Starter'.
			spec
				package: 'Application-Starter-Examples' with: [ spec requires: 'Application-Starter' ];
				group: 'Examples' with: 'Application-Starter-Examples'.
			spec
				package: 'Application-Starter-Tests'
					with: [ spec requires: #('Application-Starter' 'Application-Starter-Examples') ];
				group: 'Tests' with: 'Application-Starter-Tests'.
			spec
				group: 'Tests' with: 'Core';
				group: 'Deployment' with: 'Core';
				group: 'Development' with: 'Tests';
				group: 'CI' with: 'Tests';
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
				group: 'Core' with: 'Application-Starter-Pharo6'
			].
	spec
		for: #'pharo7.x'
		do: [ spec
				package: 'Application-Starter-Pharo7';
				group: 'Core' with: 'Application-Starter-Pharo7'
			]
]
