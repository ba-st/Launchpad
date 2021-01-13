Class {
	#name : #BaselineOfLaunchpad,
	#superclass : #BaselineOf,
	#category : #BaselineOfLaunchpad
}

{ #category : #baselines }
BaselineOfLaunchpad >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ spec
				package: 'Launchpad';
				group: 'Core' with: 'Launchpad'.
			spec
				package: 'Launchpad-Examples' with: [ spec requires: 'Launchpad' ];
				group: 'Examples' with: 'Launchpad-Examples'.
			spec
				package: 'Launchpad-Tests' with: [ spec requires: #('Launchpad' 'Launchpad-Examples') ];
				group: 'Tests' with: 'Launchpad-Tests'.
			spec
				group: 'Tests' with: 'Core';
				group: 'Deployment' with: 'Core';
				group: 'Development' with: 'Tests';
				group: 'CI' with: 'Tests';
				group: 'default' with: 'Development'
			].
	self setUpCompatibilityPackages: spec
]

{ #category : #initialization }
BaselineOfLaunchpad >> setUpCompatibilityPackages: spec [

	spec
		for: #'pharo7.x'
		do: [ spec
				package: 'Launchpad-Pharo7';
				group: 'Core' with: 'Launchpad-Pharo7'
			]
]
