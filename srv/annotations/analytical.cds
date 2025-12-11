using CVPortfolioService from '../cv-service';

/**
 * Analytical Annotations for Projects Analytics
 * Enables aggregation, grouping, and measure calculations
 */
annotate CVPortfolioService.ProjectsAnalytics with @(
  Aggregation.ApplySupported: {
    Transformations: [
      'aggregate',
      'topcount',
      'bottomcount',
      'identity',
      'concat',
      'groupby',
      'filter',
      'expand',
      'search'
    ],
    GroupableProperties: [
      ID,
      title,
      company,
      industry,
      projectType,
      startDate,
      endDate,
      role
    ],
    AggregatableProperties: [
      {
        $Type: 'Aggregation.AggregatablePropertyType',
        Property: projectCount
      }
    ]
  },

  // Define aggregated property for total project count
  Analytics.AggregatedProperty #totalProjects: {
    $Type: 'Analytics.AggregatedPropertyType',
    AggregatableProperty: projectCount,
    AggregationMethod: 'sum',
    Name: 'totalProjects',
    ![@Common.Label]: 'Total Projects'
  }
);

/**
 * Analytical Annotations for Skills Analytics
 * Enables skill proficiency aggregations
 */
annotate CVPortfolioService.SkillsAnalytics with @(
  Aggregation.ApplySupported: {
    Transformations: [
      'aggregate',
      'groupby',
      'filter'
    ],
    GroupableProperties: [
      ID,
      skillName,
      category
    ],
    AggregatableProperties: [
      {
        $Type: 'Aggregation.AggregatablePropertyType',
        Property: proficiencyLevel
      },
      {
        $Type: 'Aggregation.AggregatablePropertyType',
        Property: yearsExperience
      }
    ]
  },

  // Aggregated property for average proficiency
  Analytics.AggregatedProperty #avgProficiency: {
    $Type: 'Analytics.AggregatedPropertyType',
    AggregatableProperty: proficiencyLevel,
    AggregationMethod: 'average',
    Name: 'avgProficiency',
    ![@Common.Label]: 'Average Proficiency'
  },

  // Aggregated property for max years of experience
  Analytics.AggregatedProperty #maxExperience: {
    $Type: 'Analytics.AggregatedPropertyType',
    AggregatableProperty: yearsExperience,
    AggregationMethod: 'max',
    Name: 'maxExperience',
    ![@Common.Label]: 'Years of Experience'
  }
);

/**
 * Analytical Annotations for Technology Usage
 * Enables technology distribution analysis
 */
annotate CVPortfolioService.TechnologyUsage with @(
  Aggregation.ApplySupported: {
    Transformations: [
      'aggregate',
      'topcount',
      'bottomcount',
      'groupby',
      'filter'
    ],
    GroupableProperties: [
      technologyName,
      technologyCategory
    ],
    AggregatableProperties: [
      {
        $Type: 'Aggregation.AggregatablePropertyType',
        Property: usageCount
      }
    ]
  },

  // Aggregated property for total usage count
  Analytics.AggregatedProperty #totalUsage: {
    $Type: 'Analytics.AggregatedPropertyType',
    AggregatableProperty: usageCount,
    AggregationMethod: 'sum',
    Name: 'totalUsage',
    ![@Common.Label]: 'Total Usage Count'
  }
);
