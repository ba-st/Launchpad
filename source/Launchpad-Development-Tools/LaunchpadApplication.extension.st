Extension { #name : #LaunchpadApplication }

{ #category : #'*Launchpad-Development-Tools' }
LaunchpadApplication >> configurationParametersInspectorTab [

	<inspectorPresentationOrder: 2 title: 'Parameters'>
	^ SpTablePresenter new
		  items: self class configurationParameters;
		  addColumn: (SpStringTableColumn new
				   title: 'Name';
				   evaluated: #name;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Summary';
				   evaluated: #summary;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'CLI';
				   evaluated: #commandLineArgumentName;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Env';
				   evaluated: #environmentVariableName;
				   yourself);
		  yourself
]

{ #category : #'*Launchpad-Development-Tools' }
LaunchpadApplication >> configurationValuesInspectorTab [

	<inspectorPresentationOrder: 3 title: 'Configuration'>
	^ self configuration configurationValuesInspectorTab
]

{ #category : #'*Launchpad-Development-Tools' }
LaunchpadApplication >> configurationValuesInspectorTabContext: context [

	context active: configurationCache notNil
]

{ #category : #'*Launchpad-Development-Tools' }
LaunchpadApplication >> documentationInspectorTab [

	<inspectorPresentationOrder: 1 title: 'Docs'>
	^ SpTextPresenter new
		  text:
			  (String streamContents: [ :stream | 
					   self class printHelpOn: stream ]);
		  beWrapWord;
		  yourself
]
