using cv.portfolio from '../db/schema';

/**
 * CV Portfolio Service
 * Exposes portfolio entities with analytical capabilities for Fiori Elements
 */
service CVPortfolioService {

  /**
   * Projects - Main entity for Analytical List Page
   * Read-only analytical view with aggregation support
   */
  @readonly
  @cds.redirection.target
  entity Projects as projection on portfolio.Projects {
    *,
    // Virtual calculated field for project duration in months
    virtual null as durationMonths : Integer,
    // Virtual field for project status (Completed/Ongoing)
    virtual null as projectStatus : String(20)
  };

  /**
   * Tasks - Composition child of Projects
   * Exposed for Object Page detail sections
   */
  @readonly
  entity Tasks as projection on portfolio.Tasks;

  /**
   * Skills - Analytics entity
   * For skill proficiency visualizations
   */
  @readonly
  entity Skills as projection on portfolio.Skills;

  /**
   * Certifications - Read-only view
   * For certifications display in header cards
   */
  @readonly
  entity Certifications as projection on portfolio.Certifications;

  /**
   * Technologies - Master data
   * For value help and filtering
   */
  @readonly
  entity Technologies as projection on portfolio.Technologies;

  /**
   * ProjectTechnologies - Association entity
   * Links projects to technologies
   */
  @readonly
  @cds.redirection.target
  entity ProjectTechnologies as projection on portfolio.ProjectTechnologies;

  /**
   * Profile - Singleton entity
   * Contains personal information
   */
  @readonly
  @odata.singleton
  entity Profile as projection on portfolio.Profile;

  /**
   * Industries - Code list
   * For value help
   */
  @readonly
  entity Industries as projection on portfolio.Industries;

  /**
   * ProjectTypes - Code list
   * For value help and filtering
   */
  @readonly
  entity ProjectTypes as projection on portfolio.ProjectTypes;

  /**
   * ProjectsAnalytics - Analytical view for ALP
   * Enables aggregations and analytics for charts and KPIs
   */
  @readonly
  entity ProjectsAnalytics as projection on portfolio.Projects {
    *,
    // Expose related entities for grouping
    projectType,
    industry,
    company,
    startDate,
    endDate,

    // Virtual measures for aggregation
    virtual 1 as projectCount : Integer @(
      Analytics.Measure: true,
      Aggregation.default: #SUM
    )
  };

  /**
   * SkillsAnalytics - Analytical view for skill proficiency charts
   * Enables skill-level visualizations
   */
  @readonly
  entity SkillsAnalytics as projection on portfolio.Skills {
    *,
    skillName,
    category,
    proficiencyLevel @(
      Analytics.Measure: true,
      Aggregation.default: #AVG
    ),
    yearsExperience @(
      Analytics.Measure: true,
      Aggregation.default: #MAX
    )
  };

  /**
   * TechnologyUsage - Analytical view
   * For technology distribution charts
   */
  @readonly
  entity TechnologyUsage as select from portfolio.ProjectTechnologies {
    key ID,
    technology.name as technologyName,
    technology.category as technologyCategory,
    1 as usageCount : Integer @(
      Analytics.Measure: true,
      Aggregation.default: #SUM
    )
  };
}
