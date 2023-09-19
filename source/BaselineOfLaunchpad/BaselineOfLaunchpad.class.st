Class {
	#name : #BaselineOfLaunchpad,
	#superclass : #BaselineOf,
	#category : #BaselineOfLaunchpad
}

{ #category : #'post-load actions' }
BaselineOfLaunchpad >> addLaunchpadLogRecordAsGlobal [

	Smalltalk at: #LaunchpadLogRecord put: LogRecord
]

{ #category : #baselines }
BaselineOfLaunchpad >> baseline: spec [

	<baseline>
	spec for: #pharo do: [
		spec postLoadDoIt: #addLaunchpadLogRecordAsGlobal.
		self
			setUpDependencies: spec;
			setUpPackages: spec.

		spec
			group: 'Development' with: #( 'Tests' 'Tools' );
			group: 'CI' with: 'Tests';
			group: 'default' with: 'Development' ].

	spec for: #'pharo8.x' do: [ self setUpPharo8Packages: spec ].
	spec for: #'pharo9.x' do: [ self setUpPharo9Packages: spec ].
	spec for: #'pharo10.x' do: [ self setUpPharo10Packages: spec ].
	spec for: #'pharo11.x' do: [
		self setUpPharo11Packages: spec.
		spec preLoadDoIt: #closeWelcomeWindow ]
]

{ #category : #'post-load actions' }
BaselineOfLaunchpad >> closeWelcomeWindow [
	"Workaround for https://github.com/pharo-project/pharo/issues/13788"

	Smalltalk globals
		at: #StWelcomeBrowser
		ifPresent: [ :class |
		class allInstancesDo: [ :browser | browser owner close ] ].
	Smalltalk garbageCollect
]

{ #category : #accessing }
BaselineOfLaunchpad >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpDependencies: spec [

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v7' ];
		project: 'Buoy-Deployment' copyFrom: 'Buoy' with: [ spec loads: 'Deployment' ];
		project: 'Buoy-SUnit' copyFrom: 'Buoy' with: [ spec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Buoy-Tools' copyFrom: 'Buoy' with: [ spec loads: 'Tools' ].

	spec
		baseline: 'Bell' with: [ spec repository: 'github://ba-st/Bell:v2' ];
		project: 'Bell-Deployment' copyFrom: 'Bell' with: [ spec loads: 'Deployment' ];
		project: 'Bell-SUnit' copyFrom: 'Bell' with: [ spec loads: 'Dependent-SUnit-Extensions' ].

	spec
		baseline: 'INIParser' with: [ spec repository: 'github://ba-st-dependencies/INI-Parser:v2' ];
		project: 'INIParser-Deployment' copyFrom: 'INIParser' with: [ spec loads: 'Deployment' ].

	spec
		baseline: 'Hyperspace' with: [ spec repository: 'github://ba-st/Hyperspace:v5' ];
		project: 'Hyperspace-SUnit'
		copyFrom: 'Hyperspace'
		with: [ spec loads: 'Dependent-SUnit-Extensions' ]
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpDeploymentPackages: spec [

	spec
		package: 'Launchpad-Configuration' with: [
			spec requires:
					#( 'Bell-Deployment' 'INIParser-Deployment'
					   'Buoy-Deployment' ) ];
		group: 'Deployment' with: 'Launchpad-Configuration'.

	spec
		package: 'Launchpad-Applications'
		with: [ spec requires: 'Bell-Deployment' ];
		group: 'Deployment' with: 'Launchpad-Applications'.

	spec
		package: 'Launchpad-Commands' with: [
			spec requires:
					#( 'Launchpad-Applications' 'Launchpad-Configuration' ) ];
		group: 'Deployment' with: 'Launchpad-Commands'.

	spec
		package: 'Launchpad-Commands-Pharo'
		with: [ spec requires: 'Launchpad-Commands' ];
		group: 'Deployment' with: 'Launchpad-Commands-Pharo'.

	spec
		package: 'Launchpad-Tracing-Pharo'
		with: [ spec requires: 'Launchpad-Applications' ];
		group: 'Deployment' with: 'Launchpad-Tracing-Pharo'.

	spec
		package: 'Launchpad-Tracing'
		with: [ spec requires: 'Launchpad-Tracing-Pharo' ];
		group: 'Deployment' with: 'Launchpad-Tracing'.
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
		setUpSUnitPackages: spec;
		setUpTestPackages: spec.
		
	spec group: 'Tools' with: 'Buoy-Tools'
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpPharo10Packages: spec [

	spec
		package: 'Launchpad-Tracing-Fuel-Legacy' with: [ spec requires: 'Launchpad-Tracing' ];
		group: 'Deployment' with: 'Launchpad-Tracing-Fuel-Legacy';
		group: 'Tests' with: 'Launchpad-Tracing-Fuel-Legacy'.

	spec
		package: 'Launchpad-Development-Tools'
		with: [ spec requires: #( 'Launchpad-Applications' 'Launchpad-Configuration' ) ];
		group: 'Tools' with: 'Launchpad-Development-Tools'
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpPharo11Packages: spec [

	spec
		package: 'Launchpad-Tracing-Fuel' with: [ spec requires: 'Launchpad-Tracing' ];
		group: 'Deployment' with: 'Launchpad-Tracing-Fuel';
		group: 'Tests' with: 'Launchpad-Tracing-Fuel'
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpPharo8Packages: spec [

	spec
		package: 'Launchpad-Tracing-Fuel-Legacy' with: [ spec requires: 'Launchpad-Tracing' ];
		group: 'Deployment' with: 'Launchpad-Tracing-Fuel-Legacy';
		group: 'Tests' with: 'Launchpad-Tracing-Fuel-Legacy'.

	spec
		package: 'Launchpad-Tracing-Pharo8' with: [ spec requires: 'Launchpad-Tracing-Fuel-Legacy' ];
		group: 'Deployment' with: 'Launchpad-Tracing-Pharo8'
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpPharo9Packages: spec [

	spec
		package: 'Launchpad-Tracing-Fuel-Legacy' with: [ spec requires: 'Launchpad-Tracing' ];
		group: 'Deployment' with: 'Launchpad-Tracing-Fuel-Legacy';
		group: 'Tests' with: 'Launchpad-Tracing-Fuel-Legacy'
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpSUnitPackages: spec [

	spec
		package: 'Launchpad-SUnit' with: [ 
			spec requires:
					#( 'Buoy-SUnit' 'Bell-SUnit' 'Launchpad-Applications' 'Launchpad-Commands' ) ];
		group: 'Dependent-SUnit-Extensions' with: 'Launchpad-SUnit'
]

{ #category : #baselines }
BaselineOfLaunchpad >> setUpTestPackages: spec [

	spec
		package: 'Launchpad-Configuration-Tests'
		with: [
			spec requires: #( 'Launchpad-Configuration'
				   'Launchpad-SUnit' ) ];
		group: 'Tests' with: 'Launchpad-Configuration-Tests'.

	spec
		package: 'Launchpad-Applications-Tests'
		with: [
			spec requires: #( 'Launchpad-Applications' 'Launchpad-SUnit' ) ];
		group: 'Tests' with: 'Launchpad-Applications-Tests'.

	spec
		package: 'Launchpad-Tracing-Tests'
		with: [ spec requires: 'Launchpad-Tracing' ];
		group: 'Tests' with: 'Launchpad-Tracing-Tests'.

	spec
		package: 'Launchpad-Tracing-Pharo-Tests'
		with: [ spec requires: 'Launchpad-Tracing' ];
		group: 'Tests' with: 'Launchpad-Tracing-Pharo-Tests'.

	spec
		package: 'Launchpad-Commands-Tests' with: [
			spec requires:
					#( 'Examples' 'Launchpad-Commands' 'Launchpad-SUnit'
					   'Hyperspace-SUnit' ) ];
		group: 'Tests' with: 'Launchpad-Commands-Tests'.

	spec
		package: 'Launchpad-Commands-Pharo-Tests' with: [
			spec requires:
					#( 'Examples' 'Launchpad-Commands-Pharo'
					   'Launchpad-SUnit' 'Hyperspace-SUnit' ) ];
		group: 'Tests' with: 'Launchpad-Commands-Pharo-Tests'
]
