using { portfolio_service as S } from './service';

/* Aggregation capabilities for ALP on the GROUPED entity you chose */
annotate S.ProjectTaskStatusAgg with @Aggregation.ApplySupported: {
  Transformations        : ['aggregate','groupby','filter','search'],
  GroupableProperties    : ['project','status'],
  AggregatableProperties : [
    { $Type:'Aggregation.AggregatablePropertyType', Property: cnt, SupportedAggregationMethods:['sum'] }
  ]
};

/* Mark measure and define named aggregated measure */
annotate S.ProjectTaskStatusAgg.cnt with @Analytics.Measure: true;

annotate S.ProjectTaskStatusAgg with @Analytics.AggregatedProperty #tasksCount: {
  $Type                : 'Analytics.AggregatedPropertyType',
  Name                 : 'tasksCount',
  AggregatableProperty : cnt,
  AggregationMethod    : 'sum'
};

/* Primary visualization + PV using the same property names */
annotate S.ProjectTaskStatusAgg with @UI.Chart #Main: {
  $Type               : 'UI.ChartDefinitionType',
  Title               : 'Tasks by Status',
  ChartType           : #Column,
  Dimensions          : [ status ],
  DimensionAttributes : [{ $Type:'UI.ChartDimensionAttributeType', Dimension: status, Role:#Category }],
  DynamicMeasures     : ['@Analytics.AggregatedProperty#tasksCount'],
  MeasureAttributes   : [{ $Type:'UI.ChartMeasureAttributeType', DynamicMeasure:'@Analytics.AggregatedProperty#tasksCount', Role:#Axis1 }]
};

annotate S.ProjectTaskStatusAgg with @UI.PresentationVariant #Main: {
  Visualizations: [ { $AnnotationPath:'@UI.Chart#Main' } ]
};

/* FilterBar fields */
annotate S.ProjectTaskStatusAgg with @UI.SelectionFields : [ project, status ];
