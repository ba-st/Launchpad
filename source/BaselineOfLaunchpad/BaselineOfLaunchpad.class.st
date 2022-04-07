Class {
	#name : #BaselineOfLaunchpad,
	#superclass : #BaselineOf,
	#category : #BaselineOfLaunchpad
}

{ #category : #baselines }
BaselineOfLaunchpad >> baseline: spec [

	<baseline>
	spec for: #pharo do: [ 
		self
			setUpDependencies: spec;
			setUpPackages: spec.

		spec
			group: 'Development' with: #( 'Tests' 'Tools' );
			group: 'CI' with: 'Tests';
			group: 'default' with: 'Development' ].

	spec for: #'pharo10.x' do: [ self setUpPharo10Packages: spec ]
]

{ #category : #accessing }
BaselineOfLaunchpad >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfLaunchpad >> setUpDependencies: spec [

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v6' ];
		project: 'Buoy-Deployment' copyFrom: 'Buoy' with: [ spec loads: 'Deployment' ];
		project: 'Buoy-SUnit' copyFrom: 'Buoy' with: [ spec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Buoy-Tools' copyFrom: 'Buoy' with: [ spec loads: 'Tools' ].

	spec
		baseline: 'INIParser' with: [ spec repository: 'github://ctSkennerton/INI-Parser:v1.1.1' ];
		project: 'INIParser-Deployment' copyFrom: 'INIParser' with: [ spec loads: 'Deployment' ].

	spec
		baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON:master/repository' ];
		project: 'NeoJSON-Core' copyFrom: 'NeoJSON' with: [ spec loads: 'core' ]
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpDeploymentPackages: spec [

	spec
		package: 'Launchpad-Logging';
		group: 'Deployment' with: 'Launchpad-Logging'.

	spec
		package: 'Launchpad-Configuration'
		with: [ 
			spec requires: #( 'Launchpad-Logging' 'NeoJSON-Core' 'INIParser-Deployment'
				   'Buoy-Deployment' ) ];
		group: 'Deployment' with: 'Launchpad-Configuration'.

	spec
		package: 'Launchpad-Applications' with: [ spec requires: 'Launchpad-Logging' ];
		group: 'Deployment' with: 'Launchpad-Applications'.

	spec
		package: 'Launchpad-Commands'
		with: [ spec requires: #( 'Launchpad-Applications' 'Launchpad-Configuration' ) ];
		group: 'Deployment' with: 'Launchpad-Commands'.

	spec
		package: 'Launchpad-Tracing' with: [ spec requires: 'Launchpad-Applications' ];
		group: 'Deployment' with: 'Launchpad-Tracing'
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpExamplePackages: spec [

	spec
		package: 'Launchpad-Examples' with: [ spec requires: 'Deployment' ];
		group: 'Examples' with: #( 'Deployment' 'Launchpad-Examples' )
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpPackages: spec [

	self
		setUpDeploymentPackages: spec;
		setUpExamplePackages: spec;
		setUpTestPackages: spec.
		
	spec group: 'Tools' with: 'Buoy-Tools'
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpPharo10Packages: spec [

	spec
		package: 'Launchpad-Development-Tools' with: [ 
			spec requires:
					#( 'Launchpad-Applications' 'Launchpad-Configuration' ) ];
		group: 'Tools' with: 'Launchpad-Development-Tools'
]

{ #category : #initialization }
BaselineOfLaunchpad >> setUpTestPackages: spec [

	spec
		package: 'Launchpad-Logging-Tests' with: [ spec requires: 'Launchpad-Logging' ];
		group: 'Tests' with: 'Launchpad-Logging-Tests'.

	spec
		package: 'Launchpad-Configuration-Tests'
		with: [ spec requires: #( 'Launchpad-Configuration' 'Buoy-SUnit' ) ];
		group: 'Tests' with: 'Launchpad-Configuration-Tests'.

	spec
		package: 'Launchpad-Applications-Tests'
		with: [ spec requires: #( 'Launchpad-Applications' 'Buoy-SUnit' ) ];
		group: 'Tests' with: 'Launchpad-Applications-Tests'.

	spec
		package: 'Launchpad-Tracing-Tests' with: [ spec requires: 'Launchpad-Tracing' ];
		group: 'Tests' with: 'Launchpad-Tracing-Tests'.

	spec
		package: 'Launchpad-Commands-Tests'
		with: [ spec requires: #( 'Examples' 'Launchpad-Commands' 'Buoy-SUnit' ) ];
		group: 'Tests' with: 'Launchpad-Commands-Tests'
]
