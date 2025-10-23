// using { portfolio_service as S } from './service';

// annotate S.PortfolioExtensionMix with @Aggregation.ApplySupported: {
//   GroupableProperties    : ['extType'],
//   AggregatableProperties : ['cnt']
// };

// annotate S.PortfolioExtensionMix.extType with @Aggregation.Groupable: true;
// annotate S.PortfolioExtensionMix.cnt     with @Aggregation.Aggregatable: true;

using { portfolio_service as S } from './service';

/* Declare ALP capabilities on the grouped entity */
annotate S.ProjectTaskStatusAgg with @Aggregation.ApplySupported: {
  // Optional but helpful to be explicit:
  Transformations: ['aggregate','groupby','filter','search'],
  GroupableProperties    : ['project','status'],
  AggregatableProperties : [
    { $Type: 'Aggregation.AggregatablePropertyType', Property: cnt, SupportedAggregationMethods: ['sum'] }
  ]
};

/* Mark the raw measure property as a measure */
annotate S.ProjectTaskStatusAgg.cnt with @Analytics.Measure: true;

/* Define a named aggregated measure the UI can bind to */
annotate S.ProjectTaskStatusAgg with @Analytics.AggregatedProperty #tasksCount: {
  $Type                : 'Analytics.AggregatedPropertyType',
  Name                 : 'tasksCount',               // display name of the aggregated measure
  AggregatableProperty : cnt,
  AggregationMethod    : 'sum'
};

/* Dimensions (groupable) */
annotate S.ProjectTaskStatusAgg.project with @Aggregation.Groupable: true;
annotate S.ProjectTaskStatusAgg.status     with @Aggregation.Groupable: true;

/* (Optional but practical) Provide a default chart so ALP has a visualization */
annotate S.ProjectTaskStatusAgg with @UI.Chart: {
  $Type              : 'UI.ChartDefinitionType',
  Title              : 'Tasks by Status',
  ChartType          : #Column,
  Dimensions         : [ status ],
  DimensionAttributes: [{ $Type: 'UI.ChartDimensionAttributeType', Dimension: status, Role: #Category }],
  DynamicMeasures    : ['@Analytics.AggregatedProperty#tasksCount'],
  MeasureAttributes  : [{ $Type: 'UI.ChartMeasureAttributeType', DynamicMeasure: '@Analytics.AggregatedProperty#tasksCount', Role: #Axis1 }]
};

