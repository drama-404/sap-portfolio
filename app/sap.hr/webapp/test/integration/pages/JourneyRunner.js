sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"portfolio/sap/hr/test/integration/pages/ProjectTaskStatusAggList",
	"portfolio/sap/hr/test/integration/pages/ProjectTaskStatusAggObjectPage"
], function (JourneyRunner, ProjectTaskStatusAggList, ProjectTaskStatusAggObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('portfolio/sap/hr') + '/test/flp.html#app-preview',
        pages: {
			onTheProjectTaskStatusAggList: ProjectTaskStatusAggList,
			onTheProjectTaskStatusAggObjectPage: ProjectTaskStatusAggObjectPage
        },
        async: true
    });

    return runner;
});

