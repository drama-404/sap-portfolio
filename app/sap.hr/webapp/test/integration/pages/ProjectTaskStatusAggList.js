sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'portfolio.sap.hr',
            componentId: 'ProjectTaskStatusAggList',
            contextPath: '/ProjectTaskStatusAgg'
        },
        CustomPageDefinitions
    );
});