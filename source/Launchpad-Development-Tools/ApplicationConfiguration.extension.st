Extension { #name : #ApplicationConfiguration }

{ #category : #'*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationAsCLIInspectorTab [

	<inspectorPresentationOrder: 5 title: 'CLI'>
	^ SpTextPresenter new
		  text:
			  (String streamContents: [ :stream | self asCommandLineOn: stream ]);
		  beWrapWord;
		  yourself
]

{ #category : #'*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationAsEnvironmentInspectorTab [

	<inspectorPresentationOrder: 6 title: 'Environment'>
	^ SpTextPresenter new
		  text:
			  (String streamContents: [ :stream | self asEnvironmentOn: stream ]);
		  beWrapWord;
		  yourself
]

{ #category : #'*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationAsINIInspectorTab [

	<inspectorPresentationOrder: 4 title: 'INI'>
	^ SpTextPresenter new
		  text:
			  (String streamContents: [ :stream | self asIniFileOn: stream ]);
		  beWrapWord;
		  yourself
]

{ #category : #'*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationAsJSONInspectorTab [

	<inspectorPresentationOrder: 3 title: 'JSON'>
	^ SpTextPresenter new
		  text: self asJson;
		  beWrapWord;
		  yourself
]

{ #category : #'*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationParametersInspectorTab [

	<inspectorPresentationOrder: 2 title: 'Parameters'>
	^ SpTablePresenter new
		  items: parameters;
		  addColumn: (SpStringTableColumn new
				   title: 'Name';
				   sortFunction: #name ascending;
				   evaluated: #name;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Summary';
				   sortFunction: #summary ascending;
				   evaluated: #summary;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'CLI';
				   sortFunction: #commandLineArgumentName ascending;
				   evaluated: #commandLineArgumentName;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Env';
				   sortFunction: #environmentVariableName ascending;
				   evaluated: #environmentVariableName;
				   yourself);
		  yourself
]

{ #category : #'*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationValuesInspectorTab [

	<inspectorPresentationOrder: 1 title: 'Values'>
	^ SpTablePresenter new
		  items: parameters;
		  addColumn: (SpStringTableColumn new
				   title: 'Name';
				   sortFunction: #name ascending;
				   evaluated: #name;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Value';
				   evaluated: [:parameter | self valueFor: parameter];
				   yourself);
		  yourself
]
