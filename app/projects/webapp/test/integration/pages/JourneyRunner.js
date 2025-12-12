sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"cv/portfolio/projects/test/integration/pages/ProjectsList",
	"cv/portfolio/projects/test/integration/pages/ProjectsObjectPage"
], function (JourneyRunner, ProjectsList, ProjectsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('cv/portfolio/projects') + '/test/flp.html#app-preview',
        pages: {
			onTheProjectsList: ProjectsList,
			onTheProjectsObjectPage: ProjectsObjectPage
        },
        async: true
    });

    return runner;
});

